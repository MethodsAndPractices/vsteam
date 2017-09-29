Set-StrictMode -Version Latest
$here = Split-Path -Parent $MyInvocation.MyCommand.Path

function _handleException {
   param(
      [Parameter(Position = 1)]
      $ex
   )

   if ($ex.Exception.PSObject.Properties.Match('Response').count -gt 0 -and $ex.Exception.Response.StatusCode -ne "BadRequest") {
      $msg = "An error occurred: $($ex.Exception.Message)"
      Write-Warning $msg
   }

   Write-Warning (ConvertFrom-Json $ex.ToString()).message
}

function _isOnWindows {
   ($null -ne $env:os) -and ($env:os).StartsWith("Windows")
}

function _isOnMac {
   # The variable to test if you are on Mac OS changed from
   # IsOSX to IsMacOS. Because I have Set-StrictMode -Version Latest
   # trying to access a variable that is not set will crash.
   # So I use Test-Path to determine which exist and which to use.
   if (Test-Path variable:global:IsMacOS) {
      $IsMacOS
   }
   else {
      $IsOSX
   }
}

function _openOnWindows {
   param(
      [parameter(Mandatory = $true)]
      [string] $command
   )

   Start-Process $command
}

function _openOnMac {
   param(
      [parameter(Mandatory = $true)]
      [string] $command
   )

   open $command
}

function _openOnLinux {
   param(
      [parameter(Mandatory = $true)]
      [string] $command
   )

   xdg-open $command
}


# The url for release is special and used in more than one
# module so I moved it here.
function _buildReleaseURL {
   param(
      [parameter(Mandatory = $true)]
      [string] $projectName,
      [parameter(Mandatory = $true)]
      [string] $resource,
      [string] $version = '3.0-preview.1',
      [int] $id
   )

   if (-not $env:TEAM_ACCT) {
      throw 'You must call Add-VSTeamAccount before calling any other functions in this module.'
   }

   $resource = "release/$resource"
   $instance = $env:TEAM_ACCT

   # For VSTS Release is under .vsrm
   if ($env:TEAM_ACCT.ToLower().Contains('visualstudio.com')) {
      $instance = $env:TEAM_ACCT.ToLower().Replace('visualstudio.com', 'vsrm.visualstudio.com')
   }

   if ($id) {
      $resource += "/$id"
   }

   # elease the url to list the projects
   return "$instance/$projectName/_apis/$($resource)?api-version=$version"
}

function _appendQueryString {
   param(
      $name,
      $value
   )

   if ($value) {
      return "&$name=$value"
   }
}

function _getUserAgent {
   # Read the version from the psd1 file.
   $content = (Get-Content -Raw "$here\..\VSTeam.psd1" | Out-String)
   $r = [regex]"ModuleVersion += +'([^']+)'"
   $d = $r.Match($content)

   $os = 'unknown'

   if ($PSVersionTable.PSVersion.Major -lt 6 -or (_isOnWindows)) {
      $os = 'Windows'
   }
   elseif (_IsOnMac) {
      $os = 'OSX'
   }
   elseif ($IsLinux) {
      $os = 'Linux'
   }

   return "Team Module/$($d.Groups[1].Value) ($os) PowerShell/$($PSVersionTable.PSVersion.ToString())"
}

function _useWindowsAuthenticationOnPremise {
   return (_isOnWindows) -and (!$env:TEAM_PAT) -and -not ($env:TEAM_ACCT -like "*visualstudio.com")
}

function _getProjects {
   if (-not $env:TEAM_ACCT) {
      Write-Output @()
      return
   }

   $version = '1.0'
   $resource = "/projects"
   $instance = $env:TEAM_ACCT

   # Build the url to list the projects
   $listurl = $instance + '/_apis' + $resource + '?api-version=' + $version + '&$top=9999'
   Write-Verbose "listurl = $listurl"

   # Call the REST API
   try {
      if (_useWindowsAuthenticationOnPremise) {
         $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Uri $listurl -UseDefaultCredentials
      }
      else {
         $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Uri $listurl -Headers @{Authorization = "Basic $env:TEAM_PAT"}
      }

      if ($resp.count -gt 0) {
         Write-Output ($resp.value).name
      }
   }
   catch {
      Write-Output @()
   }
}

function _buildProjectNameDynamicParam {
   param(
      [string] $ParameterName = 'ProjectName',
      [string] $ParameterSetName,
      [bool] $Mandatory = $true,
      [string] $AliasName
   )

   # Create the dictionary
   $RuntimeParameterDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary

   # Create the collection of attributes
   $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]

   # Create and set the parameters' attributes
   $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
   $ParameterAttribute.Mandatory = $Mandatory
   $ParameterAttribute.Position = 0

   if ($ParameterSetName) {
      $ParameterAttribute.ParameterSetName = $ParameterSetName
   }

   $ParameterAttribute.ValueFromPipelineByPropertyName = $true
   $ParameterAttribute.HelpMessage = "The name of the project.  You can tab complete from the projects in your Team Services or TFS account when passed on the command line."

   # Add the attributes to the attributes collection
   $AttributeCollection.Add($ParameterAttribute)

   if ($AliasName) {
      $AliasAttribute = New-Object System.Management.Automation.AliasAttribute(@($AliasName))
      $AttributeCollection.Add($AliasAttribute)
   }

   # Generate and set the ValidateSet
   $arrSet = _getProjects

   if ($arrSet) {
      Write-Verbose "arrSet = $arrSet"
      $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($arrSet)

      # Add the ValidateSet to the attributes collection
      $AttributeCollection.Add($ValidateSetAttribute)
   }

   # Create and return the dynamic parameter
   $RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($ParameterName, [string], $AttributeCollection)
   $RuntimeParameterDictionary.Add($ParameterName, $RuntimeParameter)
   return $RuntimeParameterDictionary

   <#
   Builds a dynamic parameter that can be used to tab complete the ProjectName
   parameter of functions from a list of projects from the added TFS Account.
   You must call Add-VSTeamAccount before trying to use any function that relies
   on this dynamic parameter or you will get an error.

   This can only be used in Advanced Fucntion with the [CmdletBinding()] attribute.
   The function must also have a begin block that maps the value to a common variable
   like this.

      DynamicParam {
         # Generate and set the ValidateSet
         $arrSet = Get-VSTeamProjects | Select-Object -ExpandProperty Name

         _buildProjectNameDynamicParam -arrSet $arrSet
      }

      process {
         # Bind the parameter to a friendly variable
         $ProjectName = $PSBoundParameters[$ParameterName]
      }
   #>
}

function _buildDynamicParam {
   param(
      [string] $ParameterName = 'QueueName',
      [array] $arrSet,
      [bool] $Mandatory = $false,
      [string] $ParameterSetName
   )
   # Create the collection of attributes
   $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]

   # Create and set the parameters' attributes
   $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
   $ParameterAttribute.Mandatory = $Mandatory
   $ParameterAttribute.ValueFromPipelineByPropertyName = $true

   if ($ParameterSetName) {
      $ParameterAttribute.ParameterSetName = $ParameterSetName
   }

   # Add the attributes to the attributes collection
   $AttributeCollection.Add($ParameterAttribute)

   if ($arrSet) {
      # Generate and set the ValidateSet
      $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($arrSet)

      # Add the ValidateSet to the attributes collection
      $AttributeCollection.Add($ValidateSetAttribute)
   }

   # Create and return the dynamic parameter
   return New-Object System.Management.Automation.RuntimeDefinedParameter($ParameterName, [string], $AttributeCollection)
}