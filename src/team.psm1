[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost', '', Scope = 'Function', Target = 'Add-VSTeamAccount')]
param()

Set-StrictMode -Version Latest

# Load common code
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$here\common.ps1"

function _getModuleVersion {
   # Read the version from the psd1 file.
   $content = (Get-Content -Raw "$here\..\VSTeam.psd1" | Out-String)
   $r = [regex]"ModuleVersion += +'([^']+)'"
   $d = $r.Match($content)

   return $d.Groups[1].Value
}

# Apply types to the returned objects so format and type files can
# identify the object and act on it.
function _applyTypes {
   param(
      $item,
      $type
   )

   $item.PSObject.TypeNames.Insert(0, $type)
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

function Get-VSTeamInfo {
   return @{
      Account        = [VSTeamVersions]::Account
      Version        = [VSTeamVersions]::Version
      ModuleVersion  = [VSTeamVersions]::ModuleVersion
      DefaultProject = $Global:PSDefaultParameterValues['*:projectName']
   }
}

function Show-VSTeam {
   [CmdletBinding()]
   param ()

   process {
      _hasAccount

      Show-Browser "$([VSTeamVersions]::Account)"
   }
}

function Get-VSTeamOption {
   [CmdletBinding()]
   param([switch] $Release)

   # Build the url to list the projects
   $params = @{"Method" = "Options"}

   if ($Release.IsPresent) {
      $params.Add("SubDomain", "vsrm")
   }

   # Call the REST API
   $resp = _callAPI @params

   # Apply a Type Name so we can use custom format view and custom type extensions
   foreach ($item in $resp.value) {
      _applyTypes -item $item -type 'Team.Option'
   }

   Write-Output $resp.value
}

function Get-VSTeamResourceArea {
   [CmdletBinding()]
   param()

   # Call the REST API
   $resp = _callAPI -Resource 'resourceareas'

   # Apply a Type Name so we can use custom format view and custom type extensions
   foreach ($item in $resp.value) {
      _applyTypes -item $item -type 'Team.ResourceArea'
   }

   Write-Output $resp.value
}

function Add-VSTeamAccount {
   [CmdletBinding(DefaultParameterSetName = 'Secure')]
   param(
      [parameter(ParameterSetName = 'Windows', Mandatory = $true, Position = 1)]
      [parameter(ParameterSetName = 'Secure', Mandatory = $true, Position = 1)]
      [Parameter(ParameterSetName = 'Plain', Mandatory = $true, Position = 1)]
      [string] $Account,

      [parameter(ParameterSetName = 'Plain', Mandatory = $true, Position = 2, HelpMessage = 'Personal Access or Bearer Token')]
      [Alias('Token')]
      [string] $PersonalAccessToken,

      [parameter(ParameterSetName = 'Secure', Mandatory = $true, HelpMessage = 'Personal Access or Bearer Token')]
      [securestring] $SecurePersonalAccessToken,

      [parameter(ParameterSetName = 'Windows')]
      [parameter(ParameterSetName = 'Secure')]
      [Parameter(ParameterSetName = 'Plain')]
      [ValidateSet('TFS2017', 'TFS2018', 'VSTS')]
      [string] $Version,

      [string] $Drive,

      [parameter(ParameterSetName = 'Secure')]
      [Parameter(ParameterSetName = 'Plain')]
      [switch] $UseBearerToken
   )

   DynamicParam {
      # Create the dictionary
      $RuntimeParameterDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary

      $profileArrSet = Get-VSTeamProfile | Select-Object -ExpandProperty Name

      if ($profileArrSet) {
         $profileParam = _buildDynamicParam -ParameterName 'Profile' -ParameterSetName 'Profile' -arrSet $profileArrSet
      }
      else {
         $profileParam = _buildDynamicParam -ParameterName 'Profile' -ParameterSetName 'Profile'
      }

      $RuntimeParameterDictionary.Add('Profile', $profileParam)

      # Only add these options on Windows Machines
      if (_isOnWindows) {
         # Generate and set the ValidateSet
         $arrSet = "Process", "User"

         if (_testAdministrator) {
            $arrSet += "Machine"
         }

         $levelParam = _buildDynamicParam -ParameterName 'Level' -arrSet $arrSet
         $RuntimeParameterDictionary.Add('Level', $levelParam)

         $winAuthParam = _buildDynamicSwitchParam -ParameterName 'UseWindowsAuthentication' -Mandatory $true -ParameterSetName 'Windows'
         $RuntimeParameterDictionary.Add('UseWindowsAuthentication', $winAuthParam)
      }

      return $RuntimeParameterDictionary
   }

   process {
      # Bind the parameter to a friendly variable
      $Profile = $PSBoundParameters['Profile']

      if (_isOnWindows) {
         # Bind the parameter to a friendly variable
         $Level = $PSBoundParameters['Level']

         if (-not $Level) {
            $Level = "Process"
         }

         $UsingWindowsAuth = $PSBoundParameters['UseWindowsAuthentication']
      }
      else {
         $Level = "Process"
      }

      if ($Profile) {
         $info = Get-VSTeamProfile | Where-Object Name -eq $Profile

         if ($info) {
            $encodedPat = $info.Pat
            $account = $info.URL
            $version = $info.Version
            $token = $info.Token
         }
         else {
            Write-Error "The profile provided was not found."
            return
         }
      }
      else {
         if ($SecurePersonalAccessToken) {
            # Convert the securestring to a normal string
            # this was the one technique that worked on Mac, Linux and Windows
            $credential = New-Object System.Management.Automation.PSCredential $account, $SecurePersonalAccessToken
            $_pat = $credential.GetNetworkCredential().Password
         }
         else {
            $_pat = $PersonalAccessToken
         }

         # If they only gave an account name add https://dev.azure.com
         if ($Account -notlike "*/*") {
            $Account = "https://dev.azure.com/$($Account)"
         }
         # If they gave https://xxx.visualstudio.com convert to new URL
         if ($Account -match "(?<protocol>https?\://)?(?<account>[A-Z0-9][-A-Z0-9]*[A-Z0-9])(?<domain>\.visualstudio\.com)") {
            $Account = "https://dev.azure.com/$($matches.account)"
         }
   
         if ($UseBearerToken.IsPresent) {
            $token = $_pat
            $encodedPat = ''
         }
         else {
            $token = ''
            $encodedPat = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes(":$_pat"))
         }

         # If no SecurePersonalAccessToken is entered, and on windows, are we using default credentials for REST calls
         if ((!$_pat) -and (_isOnWindows) -and ($UsingWindowsAuth)) {
            Write-Verbose "Using Default Windows Credentials for authentication; no Personal Access Token required"
            $encodedPat = ''
            $token = ''
         }
      }

      Clear-VSTeamDefaultProject
      _setEnvironmentVariables -Level $Level -Pat $encodedPat -Acct $account -BearerToken $token -Version $Version

      Set-VSTeamAPIVersion -Version (_getVSTeamAPIVersion -Instance $account -Version $Version)

      if ($Drive) {
         # Assign to null so nothing is writen to output.
         Write-Host "`nTo map a drive run the following command:`nNew-PSDrive -Name $Drive -PSProvider SHiPS -Root 'VSTeam#VSTeamAccount'`n" -ForegroundColor Black -BackgroundColor Yellow
      }
   }
}

function Remove-VSTeamAccount {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Medium")]
   param(
      # Forces the command without confirmation
      [switch] $Force
   )

   DynamicParam {
      # Only add this option on Windows Machines
      if (_isOnWindows) {
         Write-Verbose 'On a Windows machine'

         $ParameterName = 'Level'

         # Create the dictionary
         $RuntimeParameterDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary

         # Create the collection of attributes
         $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]

         # Create and set the parameters' attributes
         $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
         $ParameterAttribute.Mandatory = $false
         $ParameterAttribute.HelpMessage = "On Windows machines allows you to store the account information at the process, user or machine level. Not available on other platforms."

         # Add the attributes to the attributes collection
         $AttributeCollection.Add($ParameterAttribute)

         # Generate and set the ValidateSet
         if (_testAdministrator) {
            $arrSet = "All", "Process", "User", "Machine"
         }
         else {
            $arrSet = "All", "Process", "User"
         }

         $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($arrSet)

         # Add the ValidateSet to the attributes collection
         $AttributeCollection.Add($ValidateSetAttribute)

         # Create and return the dynamic parameter
         $RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($ParameterName, [string], $AttributeCollection)
         $RuntimeParameterDictionary.Add($ParameterName, $RuntimeParameter)
         return $RuntimeParameterDictionary
      }
      else {
         Write-Verbose 'Not on a Windows machine'
      }
   }

   process {
      if (_isOnWindows) {
         # Bind the parameter to a friendly variable
         $Level = $PSBoundParameters[$ParameterName]

         if (-not $Level) {
            $Level = "Process"
         }
      }
      else {
         $Level = "Process"
      }

      switch ($Level) {
         "User" {
            $whatIf = "user level"
         }
         "All" {
            $whatIf = "all levels"
         }
         Default {
            $whatIf = "$Level level"
         }
      }

      if ($Force -or $pscmdlet.ShouldProcess($whatIf, "Remove Team Account")) {
         switch ($Level) {
            "Process" {
               Write-Verbose "Removing from user level."
               _clearEnvironmentVariables "Process"
            }
            "All" {
               Write-Verbose "Removing from all levels."
               Write-Verbose "Removing from proces level."
               _clearEnvironmentVariables "Process"

               Write-Verbose "Removing from user level."
               _clearEnvironmentVariables "User"

               if (_testAdministrator) {
                  Write-Verbose "Removing from machine level."
                  _clearEnvironmentVariables "Machine"
               }
               else {
                  Write-Warning "Must run as administrator to clear machine level."
               }
            }
            Default {
               Write-Verbose "Removing from $Level level."
               _clearEnvironmentVariables $Level
            }
         }

         Write-Output "Removed default project and team account information"
      }
   }
}

function Get-VSTeamAPIVersion {
   [CmdletBinding()]
   param()

   return @{
      Version                     = $([VSTeamVersions]::Version)
      Git                         = $([VSTeamVersions]::Git)
      Core                        = $([VSTeamVersions]::Core)
      Build                       = $([VSTeamVersions]::Build)
      Release                     = $([VSTeamVersions]::Release)
      DistributedTask             = $([VSTeamVersions]::DistributedTask)
      Tfvc                        = $([VSTeamVersions]::Tfvc)
      Packaging                   = $([VSTeamVersions]::Packaging)
      MemberEntitlementManagement = $([VSTeamVersions]::MemberEntitlementManagement)
      ServiceFabricEndpoint       = $([VSTeamVersions]::ServiceFabricEndpoint)
   }
}

function Set-VSTeamAPIVersion {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Low")]
   param(
      [ValidateSet('TFS2017', 'TFS2018', 'VSTS')]
      [string] $Version = 'TFS2017',
      [switch] $Force
   )

   if ($Force -or $pscmdlet.ShouldProcess($version, "Set-VSTeamAPIVersion")) {
      switch ($version) {
         'TFS2018' {
            [VSTeamVersions]::Version = 'TFS2018'
            [VSTeamVersions]::Git = '3.2'
            [VSTeamVersions]::Core = '3.2'
            [VSTeamVersions]::Build = '3.2'
            [VSTeamVersions]::Release = '4.0-preview'
            [VSTeamVersions]::DistributedTask = '4.0-preview'
            [VSTeamVersions]::Tfvc = '3.2'
            [VSTeamVersions]::Packaging = ''
            [VSTeamVersions]::MemberEntitlementManagement = ''
            [VSTeamVersions]::ServiceFabricEndpoint = '3.2'
         }
         'VSTS' {
            [VSTeamVersions]::Version = 'VSTS'
            [VSTeamVersions]::Git = '4.0'
            [VSTeamVersions]::Core = '4.0'
            [VSTeamVersions]::Build = '4.0'
            [VSTeamVersions]::Release = '4.1-preview'
            [VSTeamVersions]::DistributedTask = '4.1-preview'
            [VSTeamVersions]::Tfvc = '4.0'
            [VSTeamVersions]::Packaging = '4.0-preview'
            [VSTeamVersions]::MemberEntitlementManagement = '4.1-preview'
            [VSTeamVersions]::ServiceFabricEndpoint = '4.1-preview'
         }
         Default {
            [VSTeamVersions]::Version = 'TFS2017'
            [VSTeamVersions]::Git = '3.0'
            [VSTeamVersions]::Core = '3.0'
            [VSTeamVersions]::Build = '3.0'
            [VSTeamVersions]::Release = '3.0-preview'
            [VSTeamVersions]::DistributedTask = '3.0-preview'
            [VSTeamVersions]::Tfvc = '3.0'
            [VSTeamVersions]::Packaging = ''
            [VSTeamVersions]::MemberEntitlementManagement = ''
            [VSTeamVersions]::ServiceFabricEndpoint = ''
         }
      }
   }

   Write-Verbose [VSTeamVersions]::Version
   Write-Verbose "Git: $([VSTeamVersions]::Git)"
   Write-Verbose "Core: $([VSTeamVersions]::Core)"
   Write-Verbose "Build: $([VSTeamVersions]::Build)"
   Write-Verbose "Release: $([VSTeamVersions]::Release)"
   Write-Verbose "DistributedTask: $([VSTeamVersions]::DistributedTask)"
   Write-Verbose "Tfvc: $([VSTeamVersions]::Tfvc)"
   Write-Verbose "Packaging: $([VSTeamVersions]::Packaging)"
   Write-Verbose "MemberEntitlementManagement: $([VSTeamVersions]::MemberEntitlementManagement)"
   Write-Verbose "ServiceFabricEndpoint: $([VSTeamVersions]::ServiceFabricEndpoint)"
}

function Invoke-VSTeamRequest {
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
      [switch]$JSON,
      [string]$ContentType,
      [string]$Url
   )
   DynamicParam {
      _buildProjectNameDynamicParam -Mandatory $false
   }

   process {
      $params = $PSBoundParameters

      # We have to remove any extra parameters not used by Invoke-RestMethod
      $params.Remove('JSON') | Out-Null

      $output = _callAPI @params

      if ($JSON.IsPresent) {
         $output | ConvertTo-Json -Depth 99
      }
      else {
         $output
      }
   }
}

# Set the module version
[VSTeamVersions]::ModuleVersion = _getModuleVersion

Set-Alias gti Get-VSTeamInfo
Set-Alias ata Add-VSTeamAccount
Set-Alias ivr Invoke-VSTeamRequest
Set-Alias Get-TeamInfo Get-VSTeamInfo
Set-Alias Add-TeamAccount Add-VSTeamAccount
Set-Alias Remove-TeamAccount Remove-VSTeamAccount
Set-Alias Get-TeamOption Get-VSTeamOption
Set-Alias Get-TeamResourceArea Get-VSTeamResourceArea
Set-Alias Set-APIVersion Set-VSTeamAPIVersion
Set-Alias Get-APIVersion Get-VSTeamAPIVersion

Export-ModuleMember `
   -Function Get-VSTeamInfo, Add-VSTeamAccount, Remove-VSTeamAccount, Get-VSTeamOption, Show-VSTeam, Get-VSTeamResourceArea, Set-VSTeamAPIVersion, Invoke-VSTeamRequest, Get-VSTeamAPIVersion `
   -Alias Get-TeamInfo, Add-TeamAccount, Remove-TeamAccount, Get-TeamOption, Get-TeamResourceArea, Set-APIVersion, gti, ivr, ata, Get-APIVersion