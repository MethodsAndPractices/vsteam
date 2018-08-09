Set-StrictMode -Version Latest

function _testAdministrator {
   $user = [Security.Principal.WindowsIdentity]::GetCurrent()
   (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

function _hasAccount {
   if (-not $VSTeamVersionTable.Account) {
      throw 'You must call Add-VSTeamAccount before calling any other functions in this module.'
   }
}

function _buildRequestURI {
   [CmdletBinding()]
   param(
      [string]$resource,
      [string]$area,
      [string]$id,
      [string]$version,
      [string]$subDomain,
      [object]$queryString
   )
   DynamicParam {
      _buildProjectNameDynamicParam -Mandatory $false
   }

   process {
      _hasAccount

      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      $sb = New-Object System.Text.StringBuilder

      $sb.Append($(_addSubDomain -subDomain $subDomain)) | Out-Null

      if ($ProjectName) {
         $sb.Append("/$projectName") | Out-Null
      }

      $sb.Append("/_apis/") | Out-Null

      if ($area) {
         $sb.Append("$area/") | Out-Null
      }

      if ($resource) {
         $sb.Append("$resource/") | Out-Null
      }

      if ($id) {
         $sb.Append($id) | Out-Null
      }

      if ($version) {
         $sb.Append("?api-version=$version") | Out-Null
      }

      $url = $sb.ToString()

      if ($queryString) {
         foreach ($key in $queryString.keys) {
            $Url += _appendQueryString -name $key -value $queryString[$key]
         }
      }

      return $url
   }
}

function _handleException {
   param(
      [Parameter(Position = 1)]
      $ex
   )

   $handled = $false

   if ($ex.Exception.PSObject.Properties.Match('Response').count -gt 0 -and $ex.Exception.Response.StatusCode -ne "BadRequest") {
      $handled = $true
      $msg = "An error occurred: $($ex.Exception.Message)"
      Write-Warning $msg
   }

   try {
      $e = (ConvertFrom-Json $ex.ToString())

      $hasValueProp = $e.PSObject.Properties.Match('value')

      if (0 -eq $hasValueProp.count) {
         $handled = $true
         Write-Warning $e.message
      }
      else {
         $handled = $true
         Write-Warning $e.value.message
      }
   }
   catch {
      $msg = "An error occurred: $($ex.Exception.Message)"
   }

   if (-not $handled) {
      throw $ex
   }
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
   $os = Get-OperatingSystem
   return $os -eq 'Windows'
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
      if ($null -ne $value) {
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

   $os = Get-OperatingSystem

   $result = "Team Module/$($VSTeamVersionTable.ModuleVersion) ($os) PowerShell/$($PSVersionTable.PSVersion.ToString())"

   Write-Verbose $result

   return $result
}

function _useWindowsAuthenticationOnPremise {
   return (_isOnWindows) -and (!$env:TEAM_PAT) -and -not ($VSTeamVersionTable.Account -like "*visualstudio.com")
}

function _useBearerToken {
   return (!$env:TEAM_PAT) -and ($env:TEAM_TOKEN)
}

function _getWorkItemTypes {
   param(
      [Parameter(Mandatory = $true)]
      [string] $ProjectName
   )

   if (-not $VSTeamVersionTable.Account) {
      Write-Output @()
      return
   }

   $area = "/wit"
   $resource = "/workitemtypes"
   $instance = $VSTeamVersionTable.Account
   $version = $VSTeamVersionTable.Core

   # Build the url to list the projects
   # You CANNOT use _buildRequestURI here or you will end up
   # in an infinite loop.
   $listurl = $instance + '/' + $ProjectName + '/_apis' + $area + $resource + '?api-version=' + $version

   # Call the REST API
   try {
      $resp = _callAPI -url $listurl

      # This call returns JSON with "": which causes the ConvertFrom-Json to fail.
      # To replace all the "": with "_end":
      $resp = $resp.Replace('"":', '"_end":') | ConvertFrom-Json

      if ($resp.count -gt 0) {
         Write-Output ($resp.value).name
      }
   }
   catch {
      Write-Verbose $_
      Write-Output @()
   }
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
   # You CANNOT use _buildRequestURI here or you will end up
   # in an infinite loop.
   $listurl = $instance + '/_apis' + $resource + '?api-version=' + $version + '&stateFilter=All&$top=9999'

   # Call the REST API
   try {
      $resp = _callAPI -url $listurl

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
      [string] $AliasName,
      [int] $Position = 0
   )

   # Create the dictionary
   $RuntimeParameterDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary

   # Create the collection of attributes
   $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]

   # Create and set the parameters' attributes
   $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
   $ParameterAttribute.Mandatory = $Mandatory
   $ParameterAttribute.Position = $Position

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
   if($VSTeamProjectCache.timestamp -ne (Get-Date).Minute) {
      $arrSet = _getProjects
      $VSTeamProjectCache.projects = $arrSet
      $VSTeamProjectCache.timestamp = (Get-Date).Minute
   }
   else {
      $arrSet = $VSTeamProjectCache.projects
   }

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
      [string] $ParameterSetName,
      [int] $Position = -1
   )
   # Create the collection of attributes
   $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]

   # Create and set the parameters' attributes
   $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
   $ParameterAttribute.Mandatory = $Mandatory
   $ParameterAttribute.ValueFromPipelineByPropertyName = $true
   
   if($Position -ne -1) {
      $ParameterAttribute.Position = $Position
   }

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

   # Create and return the dynamic parameter
   return New-Object System.Management.Automation.RuntimeDefinedParameter($ParameterName, [switch], $AttributeCollection)
}

function _convertSecureStringTo_PlainText {
   [CmdletBinding()]
   param(
      [parameter(ParameterSetName = 'Secure', Mandatory = $true, HelpMessage = 'Secure String')]
      [securestring] $SecureString
   )

   # Convert the securestring to a normal string
   # this was the one technique that worked on Mac, Linux and Windows
   $credential = New-Object System.Management.Automation.PSCredential 'unknown', $SecureString
   return $credential.GetNetworkCredential().Password
}

# This is the main function for calling TFS and VSTS. It handels the auth and format of the route.
# If you need to call TFS or VSTS this is the function to use.
function _callAPI {
   param(
      [string]$resource,
      [string]$area,
      [string]$id,
      [string]$version,
      [string]$subDomain,
      [ValidateSet('Get', 'Post', 'Patch', 'Delete', 'Options', 'Put', 'Default', 'Head', 'Merge', 'Trace')]
      [string]$method,
      [Parameter(ValueFromPipeline = $true)]
      [object]$body,
      [string]$InFile,
      [string]$OutFile,
      [string]$ContentType,
      [string]$ProjectName,
      [string]$Url,
      [object]$QueryString
   )

   # If the caller did not provide a Url build it.
   if (-not $Url) {
      $buildUriParams = @{} + $PSBoundParameters;
      $extra = 'method', 'body', 'InFile', 'OutFile', 'ContentType'
      foreach ($x in $extra) { $buildUriParams.Remove($x) | Out-Null}
      $Url = _buildRequestURI @buildUriParams
   }
   elseif ($QueryString) {
      # If the caller provided the URL and QueryString we need
      # to add the querystring now
      foreach ($key in $QueryString.keys) {
         $Url += _appendQueryString -name $key -value $QueryString[$key]
      }
   }

   if ($body) {
      Write-Verbose "Body $body"
   }

   $params = $PSBoundParameters
   $params.Add('Uri', $Url)
   $params.Add('UserAgent', (_getUserAgent))

   if (_useWindowsAuthenticationOnPremise) {
      $params.Add('UseDefaultCredentials', $true)
   }
   elseif (_useBearerToken) {
      $params.Add('Headers', @{Authorization = "Bearer $env:TEAM_TOKEN"})
   }
   else {
      $params.Add('Headers', @{Authorization = "Basic $env:TEAM_PAT"})
   }

   # We have to remove any extra parameters not used by Invoke-RestMethod
   $extra = 'Area', 'Resource', 'SubDomain', 'Id', 'Version', 'JSON', 'ProjectName', 'Url', 'QueryString'
   foreach ($e in $extra) { $params.Remove($e) | Out-Null }

   $resp = Invoke-RestMethod @params

   if ($resp) {
      Write-Verbose "return type: $($resp.gettype())"
      Write-Verbose $resp
   }

   return $resp
}