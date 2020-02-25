Set-StrictMode -Version Latest

$here = Split-Path -Parent $MyInvocation.MyCommand.Path

[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "It is used in other files")]
$profilesPath = "$HOME/vsteam_profiles.json"

# Not all versions support the name features.

Function New-DynamicParam {
   <#
       .SYNOPSIS
           Helper function to simplify creating dynamic parameters
       
       .DESCRIPTION
           Helper function to simplify creating dynamic parameters
   
           Example use cases:
               Include parameters only if your environment dictates it
               Include parameters depending on the value of a user-specified parameter
               Provide tab completion and intellisense for parameters, depending on the environment
   
           Please keep in mind that all dynamic parameters you create will not have corresponding variables created.
              One of the examples illustrates a generic method for populating appropriate variables from dynamic parameters
              Alternatively, manually reference $PSBoundParameters for the dynamic parameter value
   
       .NOTES
           Credit to https://github.com/RamblingCookieMonster/PowerShell/blob/master/New-DynamicParam.ps1
           Credit to http://jrich523.wordpress.com/2013/05/30/powershell-simple-way-to-add-dynamic-parameters-to-advanced-function/
               Added logic to make option set optional
               Added logic to add RuntimeDefinedParameter to existing DPDictionary
               Added a little comment based help
   
           Credit to BM for alias and type parameters and their handling
   
       .PARAMETER Name
           Name of the dynamic parameter
   
       .PARAMETER Type
           Type for the dynamic parameter.  Default is string
   
       .PARAMETER Alias
           If specified, one or more aliases to assign to the dynamic parameter
   
       .PARAMETER ValidateSet
           If specified, set the ValidateSet attribute of this dynamic parameter
   
       .PARAMETER Mandatory
           If specified, set the Mandatory attribute for this dynamic parameter
   
       .PARAMETER ParameterSetName
           If specified, set the ParameterSet attribute for this dynamic parameter
   
       .PARAMETER Position
           If specified, set the Position attribute for this dynamic parameter
   
       .PARAMETER ValueFromPipelineByPropertyName
           If specified, set the ValueFromPipelineByPropertyName attribute for this dynamic parameter
   
       .PARAMETER HelpMessage
           If specified, set the HelpMessage for this dynamic parameter
       
       .PARAMETER DPDictionary
           If specified, add resulting RuntimeDefinedParameter to an existing RuntimeDefinedParameterDictionary (appropriate for multiple dynamic parameters)
           If not specified, create and return a RuntimeDefinedParameterDictionary (appropriate for a single dynamic parameter)
   
           See final example for illustration
   
       .EXAMPLE
           
           function Show-Free
           {
               [CmdletBinding()]
               Param()
               DynamicParam {
                   $options = @( gwmi win32_volume | %{$_.driveletter} | sort )
                   New-DynamicParam -Name Drive -ValidateSet $options -Position 0 -Mandatory
               }
               begin{
                   #have to manually populate
                   $drive = $PSBoundParameters.drive
               }
               process{
                   $vol = gwmi win32_volume -Filter "driveletter='$drive'"
                   "{0:N2}% free on {1}" -f ($vol.Capacity / $vol.FreeSpace),$drive
               }
           } #Show-Free
   
           Show-Free -Drive <tab>
   
       # This example illustrates the use of New-DynamicParam to create a single dynamic parameter
       # The Drive parameter ValidateSet populates with all available volumes on the computer for handy tab completion / intellisense
   
       .EXAMPLE
   
       # I found many cases where I needed to add more than one dynamic parameter
       # The DPDictionary parameter lets you specify an existing dictionary
       # The block of code in the Begin block loops through bound parameters and defines variables if they don't exist
   
           Function Test-DynPar{
               [cmdletbinding()]
               param(
                   [string[]]$x = $Null
               )
               DynamicParam
               {
                   #Create the RuntimeDefinedParameterDictionary
                   $Dictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
           
                   New-DynamicParam -Name AlwaysParam -ValidateSet @( gwmi win32_volume | %{$_.driveletter} | sort ) -DPDictionary $Dictionary
   
                   #Add dynamic parameters to $dictionary
                   if($x -eq 1)
                   {
                       New-DynamicParam -Name X1Param1 -ValidateSet 1,2 -mandatory -DPDictionary $Dictionary
                       New-DynamicParam -Name X1Param2 -DPDictionary $Dictionary
                       New-DynamicParam -Name X3Param3 -DPDictionary $Dictionary -Type DateTime
                   }
                   else
                   {
                       New-DynamicParam -Name OtherParam1 -Mandatory -DPDictionary $Dictionary
                       New-DynamicParam -Name OtherParam2 -DPDictionary $Dictionary
                       New-DynamicParam -Name OtherParam3 -DPDictionary $Dictionary -Type DateTime
                   }
           
                   #return RuntimeDefinedParameterDictionary
                   $Dictionary
               }
               Begin
               {
                   #This standard block of code loops through bound parameters...
                   #If no corresponding variable exists, one is created
                       #Get common parameters, pick out bound parameters not in that set
                       Function _temp { [cmdletbinding()] param() }
                       $BoundKeys = $PSBoundParameters.keys | Where-Object { (get-command _temp | select -ExpandProperty parameters).Keys -notcontains $_}
                       foreach($param in $BoundKeys)
                       {
                           if (-not ( Get-Variable -name $param -scope 0 -ErrorAction SilentlyContinue ) )
                           {
                               New-Variable -Name $Param -Value $PSBoundParameters.$param
                               Write-Verbose "Adding variable for dynamic parameter '$param' with value '$($PSBoundParameters.$param)'"
                           }
                       }
   
                   #Appropriate variables should now be defined and accessible
                       Get-Variable -scope 0
               }
           }
   
       # This example illustrates the creation of many dynamic parameters using New-DynamicParam
           # You must create a RuntimeDefinedParameterDictionary object ($dictionary here)
           # To each New-DynamicParam call, add the -DPDictionary parameter pointing to this RuntimeDefinedParameterDictionary
           # At the end of the DynamicParam block, return the RuntimeDefinedParameterDictionary
           # Initialize all bound parameters using the provided block or similar code
   
       .FUNCTIONALITY
           PowerShell Language
   
   #>
   [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification='This does not actually create anything "new"')]
   param(
       
       [string]
       $Name,
       
       [System.Type]
       $Type = [string],
   
       [string[]]
       $Alias = @(),
   
       [string[]]
       $ValidateSet,
       
       [switch]
       $Mandatory,
       
       [string]
       $ParameterSetName="__AllParameterSets",
       
       [int]
       $Position,
       
       [switch]
       $ValueFromPipelineByPropertyName,
       
       [string]
       $HelpMessage,
   
       [validatescript({
           if(-not ( $_ -is [System.Management.Automation.RuntimeDefinedParameterDictionary] -or -not $_) )
           {
               Throw "DPDictionary must be a System.Management.Automation.RuntimeDefinedParameterDictionary object, or not exist"
           }
           $True
       })]
       $DPDictionary = $false
    
   )
       #Create attribute object, add attributes, add to collection   
           $ParamAttr = New-Object System.Management.Automation.ParameterAttribute
           $ParamAttr.ParameterSetName = $ParameterSetName
           if($mandatory)
           {
               $ParamAttr.Mandatory = $True
           }
           if($Position -ne $null)
           {
               $ParamAttr.Position=$Position
           }
           if($ValueFromPipelineByPropertyName)
           {
               $ParamAttr.ValueFromPipelineByPropertyName = $True
           }
           if($HelpMessage)
           {
               $ParamAttr.HelpMessage = $HelpMessage
           }
    
           $AttributeCollection = New-Object 'Collections.ObjectModel.Collection[System.Attribute]'
           $AttributeCollection.Add($ParamAttr)
       
       #Aliases if specified
           if($Alias.count -gt 0) {
               $ParamAlias = New-Object System.Management.Automation.AliasAttribute -ArgumentList $Alias
               $AttributeCollection.Add($ParamAlias)
           }

       #param validation set if specified
           if($ValidateSet) {
               $ParamOptions = New-Object System.Management.Automation.ValidateSetAttribute -ArgumentList $ValidateSet
               $AttributeCollection.Add($ParamOptions)
           }
    
       #Create the dynamic parameter
           $Parameter = New-Object -TypeName System.Management.Automation.RuntimeDefinedParameter -ArgumentList @($Name, $Type, $AttributeCollection)
       
       #Add the dynamic parameter to an existing dynamic parameter dictionary, or create the dictionary and add it
           if($DPDictionary)
           {
               $DPDictionary.Add($Name, $Parameter)
           }
           else
           {
               $Dictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
               $Dictionary.Add($Name, $Parameter)
               $Dictionary
           }
   }

function _supportsGraph {
   _hasAccount
   if ($false -eq $(_testGraphSupport)) {
      throw 'This account does not support the graph API.'
   }
}

function _testGraphSupport {
   if (-not [VSTeamVersions]::Graph) {
      return $false
   }

   return $true
}

function _supportsFeeds {
   _hasAccount
   if ($false -eq $(_testFeedSupport)) {
      throw 'This account does not support packages.'
   }
}

function _testFeedSupport {
   if (-not [VSTeamVersions]::Packaging) {
      return $false
   }

   return $true
}

function _supportsSecurityNamespace {
   _hasAccount
   if (([VSTeamVersions]::Version -ne "VSTS") -and ([VSTeamVersions]::Version -ne "AzD")) {
      throw 'Security Namespaces are currently only supported in Azure DevOps Service (Online)'
   }
}

function _supportsMemberEntitlementManagement {
   _hasAccount
   if (-not [VSTeamVersions]::MemberEntitlementManagement) {
      throw 'This account does not support Member Entitlement.'
   }
}

function _testAdministrator {
   $user = [Security.Principal.WindowsIdentity]::GetCurrent()
   (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

function _hasAccount {
   if (-not [VSTeamVersions]::Account) {
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
      $subDomain
   )

   $instance = [VSTeamVersions]::Account

   # For VSTS Entitlements is under .vsaex
   if ($subDomain -and [VSTeamVersions]::Account.ToLower().Contains('dev.azure.com')) {
      $instance = [VSTeamVersions]::Account.ToLower().Replace('dev.azure.com', "$subDomain.dev.azure.com")
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

   $result = "Team Module/$([VSTeamVersions]::ModuleVersion) ($os) PowerShell/$($PSVersionTable.PSVersion.ToString())"

   Write-Verbose $result

   return $result
}

function _useWindowsAuthenticationOnPremise {
   return (_isOnWindows) -and (!$env:TEAM_PAT) -and -not ([VSTeamVersions]::Account -like "*visualstudio.com") -and -not ([VSTeamVersions]::Account -like "https://dev.azure.com/*")
}

function _useBearerToken {
   return (!$env:TEAM_PAT) -and ($env:TEAM_TOKEN)
}

function _getWorkItemTypes {
   param(
      [Parameter(Mandatory = $true)]
      [string] $ProjectName
   )

   if (-not [VSTeamVersions]::Account) {
      Write-Output @()
      return
   }

   $area = "/wit"
   $resource = "/workitemtypes"
   $instance = [VSTeamVersions]::Account
   $version = [VSTeamVersions]::Core

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
   if (-not [VSTeamVersions]::Account) {
      Write-Output @()
      return
   }

   $resource = "/projects"
   $instance = [VSTeamVersions]::Account
   $version = [VSTeamVersions]::Core

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

function _getProjectsWithCache {
   # Generate and set the ValidateSet
   if ($([VSTeamProjectCache]::timestamp) -ne (Get-Date).Minute) {
      $arrSet = _getProjects
      [VSTeamProjectCache]::projects = $arrSet
      [VSTeamProjectCache]::timestamp = (Get-Date).Minute
   }
   else {
      $arrSet = [VSTeamProjectCache]::projects
   }
   
   return $arrSet
}

function _buildProjectNameDynamicParam {
   param(
      [string] $ParameterName = 'ProjectName',
      [string] $ParameterSetName,
      [bool] $Mandatory = $true,
      [string] $AliasName,
      [int] $Position = 0
   )

   $helpMessage = "The name of the project.  You can tab complete from the projects in your Team Services or TFS account when passed on the command line."

   $arrSet = _getProjectsWithCache
   
   $alias = @()

   if ($AliasName)
   {
      $alias += $AliasName
   }

   return New-DynamicParam -Name $ParameterName -Position $Position -Mandatory:$Mandatory -Alias $alias -ParameterSetName $ParameterSetName `
      -ValueFromPipelineByPropertyName -HelpMessage $helpMessage -ValidateSet $arrSet

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

function _getProcesses {
   if (-not [VSTeamVersions]::Account) {
      Write-Output @()
      return
   }

   $resource = "/process/processes"
   $instance = [VSTeamVersions]::Account
   $version = [VSTeamVersions]::Core

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

function _getProcessesWithCache 
{
   # Generate and set the ValidateSet
   if ($([VSTeamProcessCache]::timestamp) -ne (Get-Date).Minute) {
      $arrSet = _getProcesses
      [VSTeamProcessCache]::processes = $arrSet
      [VSTeamProcessCache]::timestamp = (Get-Date).Minute
   }
   else {
      $arrSet = [VSTeamProcessCache]::processes
   }
   
   return $arrSet
}

function _buildProcessNameDynamicParam {
   param(
      [string] $ParameterName = 'ProcessName',
      [string] $ParameterSetName,
      [bool] $Mandatory = $true,
      [string] $AliasName,
      [int] $Position = 0
   )

   $helpMessage = "The name of the process.  You can tab complete from the processes in your Team Services or TFS account when passed on the command line."

   $arrSet = _getProcessesWithCache

   $alias = @()
   if ($AliasName)
   {
      $alias += $AliasName
   }

   return New-DynamicParam -Name $ParameterName -Position $Position -Mandatory:$Mandatory -Alias $alias -ParameterSetName $ParameterSetName `
      -ValueFromPipelineByPropertyName -HelpMessage $helpMessage -ValidateSet $arrSet

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

   $alias = @()
   if ($AliasName)
   {
      $alias += $AliasName
   }

   return (New-DynamicParam -Name $ParameterName -Position $Position -Mandatory:$Mandatory -Alias $alias -ParameterSetName $ParameterSetName `
      -HelpMessage $HelpMessage -ValidateSet $arrSet -Type $ParameterType -ValueFromPipelineByPropertyName:$ValueFromPipelineByPropertyName)[$ParameterName]
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
      [string]$Team,
      [string]$Url,
      [object]$QueryString
   )

   # If the caller did not provide a Url build it.
   if (-not $Url) {
      $buildUriParams = @{ } + $PSBoundParameters;
      $extra = 'method', 'body', 'InFile', 'OutFile', 'ContentType'
      foreach ($x in $extra) { $buildUriParams.Remove($x) | Out-Null }
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
      $params.Add('Headers', @{Authorization = "Bearer $env:TEAM_TOKEN" })
   }
   else {
      $params.Add('Headers', @{Authorization = "Basic $env:TEAM_PAT" })
   }

   # We have to remove any extra parameters not used by Invoke-RestMethod
   $extra = 'Area', 'Resource', 'SubDomain', 'Id', 'Version', 'JSON', 'ProjectName', 'Team', 'Url', 'QueryString'
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
         -Version $([VSTeamVersions]::DistributedTask)

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

function _supportsServiceFabricEndpoint {
   if (-not [VSTeamVersions]::ServiceFabricEndpoint) {
      throw 'This account does not support Service Fabric endpoints.'
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

   [VSTeamVersions]::Account = $Acct

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
   [VSTeamVersions]::DefaultProject = ''
   $Global:PSDefaultParameterValues.Remove("*:projectName")

   # This is so it can be loaded by default in the next session
   if ($Level -ne "Process") {
      [System.Environment]::SetEnvironmentVariable("TEAM_PROJECT", $null, $Level)
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

function _getDescriptorForACL {
   [cmdletbinding()]
   param(
      [parameter(Mandatory = $true, ParameterSetName = "ByUser")]
      [VSTeamUser]$User,

      [parameter(MAndatory = $true, ParameterSetName = "ByGroup")]
      [VSTeamGroup]$Group
   )

   if ($User) {
      switch ($User.Origin) {
         "vsts" {
            $sid = _getVSTeamIdFromDescriptor -Descriptor $User.Descriptor
            $descriptor = "Microsoft.TeamFoundation.Identity;$sid"
         }
         "aad" {
            $descriptor = "Microsoft.IdentityModel.Claims.ClaimsIdentity;$($User.Domain)\\$($User.PrincipalName)"
         }
         default { throw "User type not handled yet for ACL. Please report this as an issue on the VSTeam Repository: https://github.com/DarqueWarrior/vsteam/issues" }
      }
   }

   if ($Group) {
      switch ($Group.Origin) {
         "vsts" {
            $sid = _getVSTeamIdFromDescriptor -Descriptor $Group.Descriptor
            $descriptor = "Microsoft.TeamFoundation.Identity;$sid"
         }
         default { throw "Group type not handled yet for Add-VSTeamGitRepositoryPermission. Please report this as an issue on the VSTeam Repository: https://github.com/DarqueWarrior/vsteam/issues" }
      }
   }

   return $descriptor
}
