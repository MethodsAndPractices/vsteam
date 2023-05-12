$here = Split-Path -Parent $MyInvocation.MyCommand.Path

[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "It is used in other files")]
$profilesPath = "$HOME/vsteam_profiles.json"

Add-Type -AssemblyName System.Web

# This is the main function for calling TFS and VSTS. It handels the auth and format of the route.
# If you need to call TFS or VSTS this is the function to use.
function _callAPI {
   [CmdletBinding()]
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
      [string]$Team,
      [string]$Url,
      [object]$QueryString,
      [hashtable]$AdditionalHeaders = @{ },
      # Some API calls require the Project ID and not the project name.
      # However, the dynamic project name parameter only shows you names
      # and not the Project IDs. Using this flag the project name provided
      # will be converted to the Project ID when building the URI for the API
      # call.
      [switch]$UseProjectId,
      # This flag makes sure that even if a default project is set that it is
      # not used to build the URI for the API call. Not all API require or
      # allow the project to be used. Setting a default project would cause
      # that project name to be used in building the URI that would lead to
      # 404 because the URI would not be correct.
      [Alias('IgnoreDefaultProject')]
      [switch]$NoProject,
      # This flag makes sure that no specific account is used
      # some APIs do not have an account in their API uri because
      # they are not account specific in the url path itself. (e.g. user profile, pipeline billing)
      [switch]$NoAccount
   )

   process {
      # If the caller did not provide a Url build it.
      if (-not $Url) {
         $buildUriParams = @{ } + $PSBoundParameters;
         $extra = 'method', 'body', 'InFile', 'OutFile', 'ContentType', 'AdditionalHeaders'
         foreach ($x in $extra) { $buildUriParams.Remove($x) | Out-Null }
         $Url = _buildRequestURI @buildUriParams
      }
      elseif ($QueryString) {
         # If the caller provided the URL and QueryString we need
         # to add the querystring now
         $qs = [System.Web.HttpUtility]::ParseQueryString('')
         foreach ($key in $QueryString.keys) {
            if($QueryString[$key]) {
                $qs.Add($key, $QueryString[$key])
            }
         }
         # Do not assume that Url already contains a query string
         # Crude check, but this will do
         if($Url.IndexOf('?') -gt 0) {
            $Url += "&" + $qs.ToString()
         }
         else {
            $Url += "?" + $qs.ToString()
         }
      }

      if ($body) {
         Write-Verbose "Body $body"
      }

      $params = $PSBoundParameters
      Write-Verbose "Calling: $Url"
      $params.Add('Uri', $Url)
      $params.Add('UserAgent', (_getUserAgent))
      $params.Add('TimeoutSec', (_getDefaultTimeout))

      # always use utf8 and json as default content type instead of xml
      if ($false -eq $PSBoundParameters.ContainsKey("ContentType")) {
         $params.Add('ContentType', 'application/json; charset=utf-8')
      }

      # do not use header when requested. Then bearer must be provided with additional headers
      $params.Add('Headers', @{ })

      # checking if an authorization token is provided already with the additional headers
      # use case: sometimes other tokens for certain APIs have to be used (buying pipelines) in order to work
      # some parts of internal APIs use their own token based on the PAT
      if (!$AdditionalHeaders.ContainsKey("Authorization")) {
         if (_useWindowsAuthenticationOnPremise) {
            $params.Add('UseDefaultCredentials', $true)
         }
         elseif (_useBearerToken) {
            $params['Headers'].Add("Authorization", "Bearer $env:TEAM_TOKEN")
         }
         else {
            $params['Headers'].Add("Authorization", "Basic $env:TEAM_PAT")
         }
      }

      if ($AdditionalHeaders -and $AdditionalHeaders.PSObject.Properties.name -match "Keys") {
         foreach ($key in $AdditionalHeaders.Keys) {
            $params['Headers'].Add($key, $AdditionalHeaders[$key])
         }
      }

      # We have to remove any extra parameters not used by Invoke-RestMethod
      $extra = 'NoAccount', 'NoProject', 'UseProjectId', 'Area', 'Resource', 'SubDomain', 'Id', 'Version', 'JSON', 'ProjectName', 'Team', 'Url', 'QueryString', 'AdditionalHeaders', 'CustomBearer'

      foreach ($e in $extra) { $params.Remove($e) | Out-Null }

      try {
         $resp = Invoke-RestMethod @params

         if ($resp) {
            Write-Verbose "return type: $($resp.gettype())"
            Write-Verbose $resp
         }

         return $resp
      }
      catch {
         _handleException $_

         throw
      }
   }
}


# General function to manage API Calls that involve a paged response,
# either with a ContinuationToken property in the body payload or
# with a X-MS-ContinuationToken header
# TODO: Add functionality to manage paged responses based on X-MS-ContinuationToken header
# TODO: This would need to be integrated probably into the _callAPI function?
function _callAPIContinuationToken {
   [CmdletBinding()]
   param(
      [string]$Url,
      # If present, or $true, the function will manage the pages using the header
      # specified in $ContinuationTokenName.
      # If not present, or $false, the function will manage the pages using the
      # continuationToken property specified in $ContinuationTokenName.
      [switch]$UseHeader,
      # Allows to specify a header or continuation token property different of the default values.
      # If this parameter is not specified, the default value is X-MS-ContinuationToken or continuationToken
      # depending if $UseHeader is present or not, respectively
      [string]$ContinuationTokenName,
      # Property in the response body payload that contains the collecion of objects to return to the calling function
      [string]$PropertyName,
      # Number of pages to be retrieved. If 0, or not specified, it will return all the available pages
      [int]$MaxPages
   )

   if ($MaxPages -le 0){
      $MaxPages = [int32]::MaxValue
   }
   if ([string]::IsNullOrEmpty($ContinuationTokenName)) {
      if ($UseHeader.IsPresent) {
         $ContinuationTokenName = "X-MS-ContinuationToken"
      } else {
         $ContinuationTokenName = "continuationToken"
      }
   }
   $i = 0
   $obj = @()
   $apiParameters = $url
   do {
      if ($UseHeader.IsPresent) {
         throw "Continuation token from response headers not supported in this version"
      } else {
         $resp = _callAPI -url $apiParameters
         $continuationToken = $resp."$ContinuationTokenName"
         $i++
         Write-Verbose "page $i"
         $obj += $resp."$PropertyName"
         if (-not [String]::IsNullOrEmpty($continuationToken)) {
            $continuationToken = [uri]::EscapeDataString($continuationToken)
            $apiParameters = "${url}&continuationToken=$continuationToken"
         }
      }
   } while (-not [String]::IsNullOrEmpty($continuationToken) -and $i -lt $MaxPages)

   return $obj
}


# Not all versions support the name features.

function _supportsGraph {
   _hasAccount
   if ($false -eq $(_testGraphSupport)) {
      throw 'This account does not support the graph API.'
   }
}

function _testGraphSupport {
   (_getApiVersion Graph) -as [boolean]
}

function _supportsHierarchyQuery {
   _hasAccount
   if ($false -eq $(_testHierarchyQuerySupport)) {
      throw 'This account does not support the hierarchy query API.'
   }
}

function _testHierarchyQuerySupport {
   (_getApiVersion HierarchyQuery) -as [boolean]
}

function _supportsBilling {
   _hasAccount
   if ($false -eq $(_testBillingSupport)) {
      throw 'This account does not support the billing API.'
   }
}

function _testBillingSupport {
   (_getApiVersion Billing) -as [boolean]
}

function _supportVariableGroups {
   _hasAccount
   if ($false -eq $(_testVariableGroupsSupport)) {
      throw 'This account does not support the variable groups.'
   }
}

function _testVariableGroupsSupport {
   (_getApiVersion VariableGroups) -as [boolean]
}

function _supportsSecurityNamespace {
   _hasAccount
   if (([vsteam_lib.Versions]::Version -ne "VSTS") -and ([vsteam_lib.Versions]::Version -ne "AzD")) {
      throw 'Security Namespaces are currently only supported in Azure DevOps Service (Online)'
   }
}

function _supportsMemberEntitlementManagement {
   [CmdletBinding(DefaultParameterSetName="upto")]
   param(
      [parameter(ParameterSetName="upto")]
      [string]$UpTo = $null,
      [parameter(ParameterSetName="onwards")]
      [string]$Onwards = $null

   )
   _hasAccount
   $apiVer = _getApiVersion MemberEntitlementManagement
   if (-not $apiVer) {
      throw 'This account does not support Member Entitlement.'
   } elseif (-not [string]::IsNullOrEmpty($UpTo) -and $apiVer -gt $UpTo) {
      throw "EntitlementManagemen version must be equal or lower than $UpTo for this call, current value $apiVer"
   } elseif (-not [string]::IsNullOrEmpty($Onwards) -and $apiVer -lt $Onwards) {
      throw "EntitlementManagemen version must be equal or greater than $Onwards for this call, current value $apiVer"
   }
}

function _testAdministrator {
   $user = [Security.Principal.WindowsIdentity]::GetCurrent()
   (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

# When you mock this in tests be sure to add a Parameter Filter that matches
# the Service that should be used.
# Mock _getApiVersion { return '1.0-gitUnitTests' } -ParameterFilter { $Service -eq 'Git' }
# Also test in the Assert-MockCalled that the correct version was used in the URL that was
# built for the API call.
function _getApiVersion {
   [CmdletBinding(DefaultParameterSetName = 'Service')]
   [OutputType([string])]
   param (
      [parameter(ParameterSetName = 'Service', Mandatory = $true, Position = 0)]
      [ValidateSet('Build', 'Release', 'Core', 'Git', 'DistributedTask',
         'DistributedTaskReleased', 'VariableGroups', 'Tfvc',
         'Packaging', 'MemberEntitlementManagement','Version',
         'ExtensionsManagement', 'ServiceEndpoints', 'Graph',
         'TaskGroups', 'Policy', 'Processes', 'HierarchyQuery', 'Pipelines', 'Billing', 'Wiki', 'WorkItemTracking')]
      [string] $Service,

      [parameter(ParameterSetName = 'Target')]
      [switch] $Target
   )

   if ($Target.IsPresent) {
      return [vsteam_lib.Versions]::GetApiVersion("Version")
   }
   else {
      return [vsteam_lib.Versions]::GetApiVersion($Service)
   }
}

function _getInstance {
   return [vsteam_lib.Versions]::Account
}

function _getDefaultTimeout {
   if ($Global:PSDefaultParameterValues["*-vsteam*:vsteamApiTimeout"]) {
      return $Global:PSDefaultParameterValues["*-vsteam*:vsteamApiTimeout"]
   }
   else {
      return 60
   }
}

function _getDefaultProject {
   return $Global:PSDefaultParameterValues["*-vsteam*:projectName"]
}

function _hasAccount {
   if (-not $(_getInstance)) {
      throw 'You must call Set-VSTeamAccount before calling any other functions in this module.'
   }
}

function _buildRequestURI {
   [CmdletBinding()]
   param(
      [string]$team,
      [string]$resource,
      [string]$area,
      [string]$id,
      [string]$version,
      [string]$subDomain,
      [object]$queryString,

      [Parameter(Mandatory = $false)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      $ProjectName,

      [switch]$UseProjectId,
      [switch]$NoProject,
      [switch]$NoAccount
   )

   process {
      _hasAccount

      $sb = New-Object System.Text.StringBuilder

      $qs = [System.Web.HttpUtility]::ParseQueryString('')

      $instance = "https://dev.azure.com"
      if ($NoAccount.IsPresent -eq $false) {
         $instance = _getInstance
      }

      $sb.Append($(_addSubDomain -subDomain $subDomain -instance $instance)) | Out-Null

      # There are some APIs that must not have the project added to the URI.
      # However, if they caller set the default project it will be passed in
      # here and added to the URI by mistake. Functions that need the URI
      # created without the project even if the default project is set needs
      # to pass the -NoProject switch.
      if ($ProjectName -and $NoProject.IsPresent -eq $false -and $NoAccount.IsPresent -eq $false) {
         if ($UseProjectId.IsPresent) {
            $projectId = (Get-VSTeamProject -Name $ProjectName | Select-Object -ExpandProperty id)
            $sb.Append("/$projectId") | Out-Null
         }
         else {
            $sb.Append("/$projectName") | Out-Null
         }
      }

      if ($team) {
         $sb.Append("/$team") | Out-Null
      }

      $sb.Append("/_apis") | Out-Null

      if ($area) {
         $sb.Append("/$area") | Out-Null
      }

      if ($resource) {
         $sb.Append("/$resource") | Out-Null
      }

      if ($id) {
         $sb.Append("/$id") | Out-Null
      }

      if ($version) {
         $qs.Add("api-version", $version)
      }

      if ($queryString) {
         foreach ($key in $queryString.keys) {
            if($QueryString[$key]) {
                $qs.Add($key, $queryString[$key])
            }
         }
      }

      if($qs.HasKeys())
      {
         $sb.Append('?') | Out-Null
         $sb.Append($qs.ToString()) | Out-Null
      }

      $url = $sb.ToString()

      return $url
   }
}

function _handleException {
   param(
      [Parameter(Position = 1)]
      $ex
   )

   $handled = $false

   if ($ex.Exception.PSObject.Properties.Match('Response').count -gt 0 -and
      $null -ne $ex.Exception.Response -and
      $ex.Exception.Response.StatusCode -ne "BadRequest") {
      $handled = $true
      $msg = "An error occurred: $($ex.Exception.Message)"
      Write-Warning -Message $msg
   }

   try {
      $e = (ConvertFrom-Json $ex.ToString())

      $hasValueProp = $e.PSObject.Properties.Match('value')

      if (0 -eq $hasValueProp.count) {
         $handled = $true
         Write-Warning -Message $e.message
      }
      else {
         $handled = $true
         Write-Warning -Message $e.value.message
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
   return $instance -like "*.visualstudio.com*" -or $instance -like "https://dev.azure.com/*"
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
      [string] $subDomain,
      [string] $instance
   )

   # For VSTS Entitlements is under .vsaex
   if ($subDomain -and $instance.ToLower().Contains('dev.azure.com')) {
      $instance = $instance.ToLower().Replace('dev.azure.com', "$subDomain.dev.azure.com")
   }

   return $instance
}

function _getUserAgent {
   [CmdletBinding()]
   param()

   $os = Get-OperatingSystem

   $result = "Team Module/$([vsteam_lib.Versions]::ModuleVersion) ($os) PowerShell/$($PSVersionTable.PSVersion.ToString())"

   Write-Verbose $result

   return $result
}

function _useWindowsAuthenticationOnPremise {
   return (_isOnWindows) -and (!$env:TEAM_PAT) -and -not ($(_getInstance) -like "*visualstudio.com") -and -not ($(_getInstance) -like "https://dev.azure.com/*")
}

function _useBearerToken {
   return (!$env:TEAM_PAT) -and ($env:TEAM_TOKEN)
}

function _getWorkItemTypes {
   param(
      [Parameter(Mandatory = $true)]
      [string] $ProjectName
   )

   if (-not $(_getInstance)) {
      Write-Output @()
      return
   }

   # Call the REST API
   try {
      $resp = _callAPI -ProjectName $ProjectName `
         -area wit `
         -resource workitemtypes `
         -version $(_getApiVersion Core)

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

function _buildLevelDynamicParam {
   param ()
   # # Only add these options on Windows Machines
   if (_isOnWindows) {
      $ParameterName = 'Level'

      # Create the dictionary
      $RuntimeParameterDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary

      # Create the collection of attributes
      $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]

      # Create and set the parameters' attributes
      $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
      $ParameterAttribute.Mandatory = $false
      $ParameterAttribute.HelpMessage = "On Windows machines allows you to store the default project at the process, user or machine level. Not available on other platforms."

      # Add the attributes to the attributes collection
      $AttributeCollection.Add($ParameterAttribute)

      # Generate and set the ValidateSet
      if (_testAdministrator) {
         $arrSet = "Process", "User", "Machine"
      }
      else {
         $arrSet = "Process", "User"
      }

      $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($arrSet)

      # Add the ValidateSet to the attributes collection
      $AttributeCollection.Add($ValidateSetAttribute)

      # Create and return the dynamic parameter
      $RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($ParameterName, [string], $AttributeCollection)
      $RuntimeParameterDictionary.Add($ParameterName, $RuntimeParameter)
      return $RuntimeParameterDictionary
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
   $arrSet = [vsteam_lib.ProjectCache]::GetCurrent($false)

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
   You must call Set-VSTeamAccount before trying to use any function that relies
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

function _buildProcessNameDynamicParam {
   param(
      [string] $ParameterName = 'ProcessName',
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
   $ParameterAttribute.HelpMessage = "The name of the process.  You can tab complete from the processes in your Team Services or TFS account when passed on the command line."

   # Add the attributes to the attributes collection
   $AttributeCollection.Add($ParameterAttribute)

   if ($AliasName) {
      $AliasAttribute = New-Object System.Management.Automation.AliasAttribute(@($AliasName))
      $AttributeCollection.Add($AliasAttribute)
   }

   # Generate and set the ValidateSet
   $arrSet = [vsteam_lib.ProcessTemplateCache]::GetCurrent()

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
   You must call Set-VSTeamAccount before trying to use any function that relies
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
      [int] $Position = -1,
      [type] $ParameterType = [string],
      [bool] $ValueFromPipelineByPropertyName = $true,
      [string] $AliasName,
      [string] $HelpMessage
   )
   # Create the collection of attributes
   $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
   <#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER ParameterName
Parameter description

.PARAMETER ParameterSetName
Parameter description

.PARAMETER Mandatory
Parameter description

.PARAMETER AliasName
Parameter description

.PARAMETER Position
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
   # Create and set the parameters' attributes
   $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
   $ParameterAttribute.Mandatory = $Mandatory
   $ParameterAttribute.ValueFromPipelineByPropertyName = $ValueFromPipelineByPropertyName

   if ($Position -ne -1) {
      $ParameterAttribute.Position = $Position
   }

   if ($ParameterSetName) {
      $ParameterAttribute.ParameterSetName = $ParameterSetName
   }

   if ($HelpMessage) {
      $ParameterAttribute.HelpMessage = $HelpMessage
   }

   # Add the attributes to the attributes collection
   $AttributeCollection.Add($ParameterAttribute)

   if ($AliasName) {
      $AliasAttribute = New-Object System.Management.Automation.AliasAttribute(@($AliasName))
      $AttributeCollection.Add($AliasAttribute)
   }

   if ($arrSet) {
      # Generate and set the ValidateSet
      $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($arrSet)

      # Add the ValidateSet to the attributes collection
      $AttributeCollection.Add($ValidateSetAttribute)
   }

   # Create and return the dynamic parameter
   return New-Object System.Management.Automation.RuntimeDefinedParameter($ParameterName, $ParameterType, $AttributeCollection)
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

function _trackProjectProgress {
   param(
      [Parameter(Mandatory = $true)] $Resp,
      [string] $Title,
      [string] $Msg
   )

   $i = 0
   $x = 1
   $y = 10
   $status = $resp.status

   # Track status
   while ($status -ne 'failed' -and $status -ne 'succeeded') {
      $status = (_callAPI -Url $resp.url).status

      # oscillate back a forth to show progress
      $i += $x
      Write-Progress -Activity $title -Status $msg -PercentComplete ($i / $y * 100)

      if ($i -eq $y -or $i -eq 0) {
         $x *= -1
      }
   }
}

$iTracking = 0
$xTracking = 1
$yTracking = 10
$statusTracking = $null

function _trackServiceEndpointProgress {
   param(
      [Parameter(Mandatory = $true)]
      [string] $projectName,

      [Parameter(Mandatory = $true)]
      $resp,

      [string] $title,

      [string] $msg
   )

   $iTracking = 0
   $xTracking = 1
   $yTracking = 10

   $isReady = $false

   # Track status
   while (-not $isReady) {
      $statusTracking = _callAPI -ProjectName $projectName -Area 'distributedtask' -Resource 'serviceendpoints' -Id $resp.id  `
         -Version $(_getApiVersion ServiceEndpoints)

      $isReady = $statusTracking.isReady;

      if (-not $isReady) {
         $state = $statusTracking.operationStatus.state

         if ($state -eq "Failed") {
            throw $statusTracking.operationStatus.statusMessage
         }
      }

      # oscillate back a forth to show progress
      $iTracking += $xTracking
      Write-Progress -Activity $title -Status $msg -PercentComplete ($iTracking / $yTracking * 100)

      if ($iTracking -eq $yTracking -or $iTracking -eq 0) {
         $xTracking *= -1
      }
   }
}

function _getModuleVersion {
   # Read the version from the psd1 file.
   # $content = (Get-Content -Raw "./VSTeam.psd1" | Out-String)
   $content = (Get-Content -Raw "$here\VSTeam.psd1" | Out-String)
   $r = [regex]"ModuleVersion += +'([^']+)'"
   $d = $r.Match($content)

   return $d.Groups[1].Value
}

function _setEnvironmentVariables {
   [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "")]
   param (
      [string] $Level = "Process",
      [string] $Pat,
      [string] $Acct,
      [string] $BearerToken,
      [string] $Version
   )

   # You always have to set at the process level or they will Not
   # be seen in your current session.
   $env:TEAM_PAT = $Pat
   $env:TEAM_ACCT = $Acct
   $env:TEAM_VERSION = $Version
   $env:TEAM_TOKEN = $BearerToken

   [vsteam_lib.Versions]::Account = $Acct

   # This is so it can be loaded by default in the next session
   if ($Level -ne "Process") {
      [System.Environment]::SetEnvironmentVariable("TEAM_PAT", $Pat, $Level)
      [System.Environment]::SetEnvironmentVariable("TEAM_ACCT", $Acct, $Level)
      [System.Environment]::SetEnvironmentVariable("TEAM_VERSION", $Version, $Level)
   }
}

# If you remove an account the current default project needs to be cleared as well.
function _clearEnvironmentVariables {
   [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "")]
   param (
      [string] $Level = "Process"
   )

   $env:TEAM_PROJECT = $null
   $env:TEAM_TIMEOUT = $null
   [vsteam_lib.Versions]::DefaultProject = ''
   [vsteam_lib.Versions]::DefaultTimeout = ''
   $Global:PSDefaultParameterValues.Remove("*-vsteam*:projectName")
   $Global:PSDefaultParameterValues.Remove("*-vsteam*:vsteamApiTimeout")

   # This is so it can be loaded by default in the next session
   if ($Level -ne "Process") {
      [System.Environment]::SetEnvironmentVariable("TEAM_PROJECT", $null, $Level)
      [System.Environment]::SetEnvironmentVariable("TEAM_TIMEOUT", $null, $Level)
   }

   _setEnvironmentVariables -Level $Level -Pat '' -Acct '' -UseBearerToken '' -Version ''
}

function _convertToHex() {
   [cmdletbinding()]
   param(
      [parameter(Mandatory = $true)]
      [string]$Value
   )

   $bytes = $Value | Format-Hex -Encoding Unicode
   $hexString = ($bytes.Bytes | ForEach-Object ToString X2) -join ''
   return $hexString.ToLowerInvariant();
}

function _getVSTeamIdFromDescriptor {
   [cmdletbinding()]
   param(
      [parameter(Mandatory = $true)]
      [string]$Descriptor
   )

   $identifier = $Descriptor.Split('.')[1]

   # We need to Pad the string for FromBase64String to work reliably (AzD Descriptors are not padded)
   $ModulusValue = ($identifier.length % 4)
   Switch ($ModulusValue) {
      '0' { $Padded = $identifier }
      '1' { $Padded = $identifier.Substring(0, $identifier.Length - 1) }
      '2' { $Padded = $identifier + ('=' * (4 - $ModulusValue)) }
      '3' { $Padded = $identifier + ('=' * (4 - $ModulusValue)) }
   }

   return [System.Text.Encoding]::ASCII.GetString([System.Convert]::FromBase64String($Padded))
}

function _getPermissionInheritanceInfo {
   [cmdletbinding()]
   [OutputType([System.Collections.Hashtable])]
   param(
      [parameter(Mandatory = $true)]
      [string] $projectName,

      [parameter(Mandatory = $true)]
      [string] $resourceName,
      [Parameter(Mandatory = $true)]

      [ValidateSet('Repository', 'BuildDefinition', 'ReleaseDefinition')]
      [string] $resourceType
   )

   $projectId = (Get-VSTeamProject -Name $projectName | Select-Object -ExpandProperty id)

   Switch ($resourceType) {
      "Repository" {
         $securityNamespaceID = "2e9eb7ed-3c0a-47d4-87c1-0ffdd275fd87"

         $repositoryId = (Get-VSTeamGitRepository -Name "$resourceName" -projectName $projectName | Select-Object -ExpandProperty id )

         if ($null -eq $repositoryId) {
            Write-Error "Unable to retrieve repository information. Ensure that the resourceName provided matches a repository name exactly."
            return
         }

         $token = "repoV2/$($projectId)/$repositoryId"
      }

      "BuildDefinition" {
         $securityNamespaceID = "33344d9c-fc72-4d6f-aba5-fa317101a7e9"

         $buildDefinitionId = (Get-VSTeamBuildDefinition -projectName $projectName | Where-Object name -eq "$resourceName" | Select-Object -ExpandProperty id)

         if ($null -eq $buildDefinitionId) {
            Write-Error "Unable to retrieve build definition information. Ensure that the resourceName provided matches a build definition name exactly."
            return
         }

         $token = "$($projectId)/$buildDefinitionId"
      }

      "ReleaseDefinition" {
         $securityNamespaceID = "c788c23e-1b46-4162-8f5e-d7585343b5de"

         $releaseDefinition = (Get-VSTeamReleaseDefinition -projectName $projectName | Where-Object -Property name -eq "$resourceName")

         if ($null -eq $releaseDefinition) {
            Write-Error "Unable to retrieve release definition information. Ensure that the resourceName provided matches a release definition name exactly."
            return
         }

         if (($releaseDefinition).path -eq "/") {
            $token = "$($projectId)/$($releaseDefinition.id)"
         }
         else {
            $token = "$($projectId)" + "$($releaseDefinition.path -replace "\\","/")" + "/$($releaseDefinition.id)"
         }
      }
   }

   return @{
      Token               = $token
      ProjectID           = $projectId
      SecurityNamespaceID = $securityNamespaceID
   }
}

function _getDescriptorForACL {
   [cmdletbinding()]
   param(
      [parameter(Mandatory = $true, ParameterSetName = "ByUser")]
      [vsteam_lib.User]$User,

      [parameter(MAndatory = $true, ParameterSetName = "ByGroup")]
      [vsteam_lib.Group]$Group
   )

   if ($User) {
      switch ($User.Origin) {
         "vsts" {
            $sid = _getVSTeamIdFromDescriptor -Descriptor $User.Descriptor

            if ($User.Descriptor.StartsWith('svc.')) {
               $descriptor = "Microsoft.TeamFoundation.ServiceIdentity;$sid"
            }
            else {
               $descriptor = "Microsoft.TeamFoundation.Identity;$sid"
            }
         }
         "aad" {
            $descriptor = "Microsoft.IdentityModel.Claims.ClaimsIdentity;$($User.Domain)\\$($User.PrincipalName)"
         }
         default { throw "User type not handled yet for ACL. Please report this as an issue on the VSTeam Repository: https://github.com/MethodsAndPractices/vsteam/issues" }
      }
   }

   if ($Group) {
      switch ($Group.Origin) {
         "vsts" {
            $sid = _getVSTeamIdFromDescriptor -Descriptor $Group.Descriptor
            $descriptor = "Microsoft.TeamFoundation.Identity;$sid"
         }
         default { throw "Group type not handled yet for Add-VSTeamGitRepositoryPermission. Please report this as an issue on the VSTeam Repository: https://github.com/MethodsAndPractices/vsteam/issues" }
      }
   }

   return $descriptor
}

function _getBillingToken {
   # get a billing access token by using the given PAT.
   # this token can be used for buying pipelines or artifacts
   # or other things used for billing (except user access levels)
   [CmdletBinding()]
   param (
      #billing token can have different scopes. They are defined by named token ids.
      #They should be validated to be specific by it's name
      [Parameter(Mandatory = $true)]
      [string]
      [ValidateSet('AzCommDeploymentProfile', 'CommerceDeploymentProfile')]
      $NamedTokenId
   )

   $sessionToken = @{
      appId        = 00000000 - 0000 - 0000 - 0000 - 000000000000
      force        = $false
      tokenType    = 0
      namedTokenId = $NamedTokenId
   }

   $billingToken = _callAPI `
      -NoProject `
      -method POST `
      -ContentType "application/json" `
      -area "WebPlatformAuth" `
      -resource "SessionToken" `
      -version '3.2-preview.1' `
      -body ($sessionToken | ConvertTo-Json -Depth 50 -Compress)

   return $billingToken
}

# pin if github is availabe and client has access to github
function _pinpGithub {
   Write-Verbose "Checking if client is online"
   $pingGh = [System.Net.NetworkInformation.Ping]::new()
   $replyStatus = $null
   try {
      [System.Net.NetworkInformation.PingReply]$reply = $pingGh.Send('github.com', 150)
      $replyStatus = $reply.Status
   }
   catch {
      $replyStatus = [System.Net.NetworkInformation.IPStatus]::Unknown
      Write-Debug $_.Exception.InnerException
   }
   return $replyStatus
}

function _showModuleLoadingMessages {
   [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '',
      Justification = 'False positive. Parameter is being used, but not catched when used in script blocks. see: https://github.com/PowerShell/PSScriptAnalyzer/issues/1472')]
   [CmdletBinding()]
   param (
      # version of the module
      [Parameter(Mandatory = $true)]
      [version]
      $ModuleVersion
   )

   process {
      if ((_pinpGithub) -eq [System.Net.NetworkInformation.IPStatus]::Success) {
         # catch if web request fails. Invoke-WebRequest does not have a ErrorAction parameter
         try {

            $moduleMessagesRes = (Invoke-RestMethod "https://raw.githubusercontent.com/MethodsAndPractices/vsteam/trunk/.github/moduleMessages.json")

            # don't show messages if module has not the specified version
            $filteredMessages = $moduleMessagesRes | Where-Object {

               $returnMessage = $true

               if (-not [String]::IsNullOrEmpty($_.displayFromVersion)) {
                  $returnMessage = ([version]$_.displayFromVersion) -le $ModuleVersion
               }

               if (-not [String]::IsNullOrEmpty($_.displayToVersion) -and $returnMessage -eq $true) {
                  $returnMessage = ([version]$_.displayToVersion) -ge $ModuleVersion
               }

               return $returnMessage
            }

            # dont show messages if display until date is in the past
            $currentDate = Get-Date
            $filteredMessages = $filteredMessages | Where-Object { $currentDate -le ([DateTime]::Parse($_.toDate))
            }

            # stop processing if no messages left
            if ($null -eq $filteredMessages -or $filteredMessages.Count -eq 0) {
               return
            }

            $filteredMessages | ForEach-Object {
               $messageFormat = "{0}: {1}"
               Write-Information ($messageFormat -f $_.type.ToUpper(), $_.msg) -InformationAction Continue
            }
         }
         catch {
            Write-Debug "Error: $_"
         }
      }
      else {
         Write-Information "Client is offline or blocked by a firewall. Skipping module messages"
      }
   }
}

function _checkForModuleUpdates {
   [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '',
      Justification = 'False positive. Parameter is being used, but not catched when used in script blocks. see: https://github.com/PowerShell/PSScriptAnalyzer/issues/1472')]
   [CmdletBinding()]
   param (
      # version of the module
      [Parameter(Mandatory = $true)]
      [version]
      $ModuleVersion
   )

   process {

      # check if client has online access
      if ((_pinpGithub) -eq [System.Net.NetworkInformation.IPStatus]::Success) {

         # catch if web request fails. Invoke-WebRequest does not have a ErrorAction parameter
         try {
            Write-Verbose "Checking if module is up to date"
            $ghLatestRelease = Invoke-RestMethod "https://api.github.com/repos/MethodsAndPractices/vsteam/releases/latest"

            [version]$latestVersion = $ghLatestRelease.tag_name -replace "v", ""
            [version]$currentVersion = $ModuleVersion

            if ($currentVersion -lt $latestVersion) {
               Write-Information "New version available: $latestVersion" -InformationAction Continue
               Write-Information "Run to update: Update-Module -Name VSTeam -RequiredVersion $latestVersion `n" -InformationAction Continue
            }
         }
         catch {
            Write-Debug "Error: $_"
         }
      }
      else {
         Write-Information "Client is offline or blocked by a firewall. Skipping module updates check"
      }
   }

}

function _countParameters() {
   param(
      $BoundParameters
   )
   $counter = 0
   $advancedPameters = @('Verbose', 'Debug', 'ErrorAction', 'WarningAction', 'InformationAction', 'ErrorVariable', 'WarningVariable', 'InformationVariable', 'OutVariable', 'OutBuffer', 'PipelineVariable')
   foreach($p in $BoundParameters.GetEnumerator()) {
      if ($p.Key -notin $advancedPameters) {
         $counter++
      }
   }
   Write-Verbose "Found $counter parameters"
   $counter
}

function _invalidate() {
   [vsteam_lib.ProjectCache]::Invalidate()
}