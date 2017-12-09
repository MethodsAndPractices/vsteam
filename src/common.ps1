Set-StrictMode -Version Latest

function _hasAccount {
   if (-not $VSTeamVersionTable.Account) {
      throw 'You must call Add-VSTeamAccount before calling any other functions in this module.'
   }
}

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

function _isVSTS {
   param(
      [parameter(Mandatory = $true)]
      [string] $instance
   )
   return $instance -like "*.visualstudio.com*"
}

function _getVSTeamAPIVersion {
   param(
      [parameter(Mandatory = $true)]
      [string] $instance,
      [string] $Version
   )

   if ($Version) {
      return $Version
   }
   else {
      if (_isVSTS $instance) {
         return 'VSTS'
      }
      else {
         return 'TFS2017'
      }
   }
}

function _isOnWindows {
   # This will work on 6.0 and later but is missing on
   # older versions
   if (Test-Path -Path 'variable:global:IsWindows') {
      return Get-Content -Path 'variable:global:IsWindows'
   }
   # This should catch older versions
   elseif (Test-Path -Path 'env:os') {
      return (Get-Content -Path 'env:os').StartsWith("Windows")
   }
   # If all else fails
   else {
      return $false
   }
}

function _isOnLinux {
   if (Test-Path -Path 'variable:global:IsLinux') {
      return Get-Content -Path 'variable:global:IsLinux'
   }

   return $false
}

function _isOnMac {
   # The variable to test if you are on Mac OS changed from
   # IsOSX to IsMacOS. Because I have Set-StrictMode -Version Latest
   # trying to access a variable that is not set will crash.
   # So I use Test-Path to determine which exist and which to use.
   if (Test-Path -Path 'variable:global:IsMacOS') {
      return Get-Content -Path 'variable:global:IsMacOS'
   }
   elseif (Test-Path -Path 'variable:global:IsOSX') {
      return Get-Content -Path 'variable:global:IsOSX'
   }
   else {
      return $false
   }
}

function _openOnWindows {
   param(
      [parameter(Mandatory = $true)]
      [string] $command
   )

   Start-Process "$command"
}

function _openOnMac {
   param(
      [parameter(Mandatory = $true)]
      [string] $command
   )

   Start-Process -FilePath open -Args "$command"
}

function _openOnLinux {
   param(
      [parameter(Mandatory = $true)]
      [string] $command
   )

   Start-Process -FilePath xdg-open -Args "$command"
}

function _showInBrowser {
   param(
      [parameter(Mandatory = $true)]
      [string] $url
   )

   Write-Verbose $url
         
   if (_isOnWindows) {
      _openOnWindows $url
   }
   elseif (_isOnMac) {
      _openOnMac $url
   }
   else {
      _openOnLinux $url
   }
}

function _addSubDomain {
   param(
      $subDomain
   )

   $instance = $VSTeamVersionTable.Account
   
   # For VSTS Entitlements is under .vsaex
   if ($subDomain -and $VSTeamVersionTable.Account.ToLower().Contains('visualstudio.com')) {
      $instance = $VSTeamVersionTable.Account.ToLower().Replace('visualstudio.com', "$subDomain.visualstudio.com")
   }

   return $instance
}

function _getEntitlementBase {
   return _addSubDomain -subDomain 'vsaex'
}

function _getReleaseBase {
   return _addSubDomain -subDomain 'vsrm'
}

# The url for release is special and used in more than one
# module so I moved it here.
function _buildReleaseURL {
   param(
      [string] $projectName,
      [parameter(Mandatory = $true)]
      [string] $resource,
      [string] $version = $VSTeamVersionTable.Release,
      [int] $id
   )

   _hasAccount

   $resource = "release/$resource"
   $instance = _getReleaseBase

   if ($id) {
      $resource += "/$id"
   }

   # elease the url to list the projects
   return "$instance/$projectName/_apis/$($resource)?api-version=$version"
}

function _appendQueryString {
   param(
      $name,
      $value,
      # When provided =0 will be outputed otherwise zeros will not be
      # added. I had to add this for the userentitlements that is the only
      # VSTS API I have found that requires Top and Skip to be passed in.
      [Switch]$retainZero
   )

   if ($retainZero.IsPresent) {
      if ($value -ne $null) {
         return "&$name=$value"
      }
   }
   else {
      if ($value) {
         return "&$name=$value"
      }
   }
}

function _getUserAgent {
   [CmdletBinding()]
   param()

   $os = 'unknown'

   if (_isOnWindows) {
      $os = 'Windows'
   }
   elseif (_isOnMac) {
      $os = 'OSX'
   }
   elseif (_isOnLinux) {
      $os = 'Linux'
   }

   $result = "Team Module/$($VSTeamVersionTable.ModuleVersion) ($os) PowerShell/$($PSVersionTable.PSVersion.ToString())"

   Write-Verbose $result

   return $result
}

function _useWindowsAuthenticationOnPremise {
   return (_isOnWindows) -and (!$env:TEAM_PAT) -and -not ($VSTeamVersionTable.Account -like "*visualstudio.com")
}

function _getProjects {
   if (-not $VSTeamVersionTable.Account) {
      Write-Output @()
      return
   }

   $resource = "/projects"
   $instance = $VSTeamVersionTable.Account
   $version = $VSTeamVersionTable.Core

   # Build the url to list the projects
   $listurl = $instance + '/_apis' + $resource + '?api-version=' + $version + '&stateFilter=All&$top=9999'
   Write-Verbose "listurl = $listurl"

   # Call the REST API
   try {
      $resp = _get -url $listurl
      
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

function _buildDynamicSwitchParam {
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
   return New-Object System.Management.Automation.RuntimeDefinedParameter($ParameterName, [switch], $AttributeCollection)
}

function _get {
   param(
      [string] $url
   )

   if (_useWindowsAuthenticationOnPremise) {
      $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Method Get -Uri $url -UseDefaultCredentials
   }
   else {
      $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Method Get -Uri $url -Headers @{Authorization = "Basic $env:TEAM_PAT"}
   }

   return $resp
}

function _postFile {
   param(
      [string] $url,
      [string] $inFile
   )

   if (_useWindowsAuthenticationOnPremise) {
      $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Method Post -Uri $url -ContentType "application/json" -UseDefaultCredentials -InFile $inFile
   }
   else {
      $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Method Post -Uri $url -ContentType "application/json" -Headers @{Authorization = "Basic $env:TEAM_PAT"} -InFile $inFile
   }

   return $resp
}

function _post {
   param(
      [string] $url,
      [string] $body
   )

   if (_useWindowsAuthenticationOnPremise) {
      $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Method Post -ContentType "application/json" -Body $body -Uri $url -UseDefaultCredentials
   }
   else {
      $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Method Post -ContentType "application/json" -Body $body -Uri $url -Headers @{Authorization = "Basic $env:TEAM_PAT"}
   }

   return $resp
}

function _patch {
   param(
      [string] $url,
      [string] $body
   )

   if (_useWindowsAuthenticationOnPremise) {
      $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Method Patch -ContentType "application/json" -Body $body -Uri $url -UseDefaultCredentials
   }
   else {
      $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Method Patch -ContentType "application/json" -Body $body -Uri $url -Headers @{Authorization = "Basic $env:TEAM_PAT"}
   }

   return $resp
}

function _delete {
   param(
      [string] $url
   )

   if (_useWindowsAuthenticationOnPremise) {
      $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Method Delete -Uri $url -UseDefaultCredentials
   }
   else {
      $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Method Delete -Uri $url -Headers @{Authorization = "Basic $env:TEAM_PAT"}
   }

   return $resp
}

function _put {
   param(
      [string] $url
   )

   if (_useWindowsAuthenticationOnPremise) {
      $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Method Put -Uri $url -UseDefaultCredentials
   }
   else {
      $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Method Put -Uri $url -Headers @{Authorization = "Basic $env:TEAM_PAT"}
   }

   return $resp
}

function _options {
   param(
      [string] $url
   )

   if (_useWindowsAuthenticationOnPremise) {
      $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Method Options -Uri $url -UseDefaultCredentials
   }
   else {
      $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Method Options -Uri $url -Headers @{Authorization = "Basic $env:TEAM_PAT"}
   }

   return $resp
}