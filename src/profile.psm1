Set-StrictMode -Version Latest

# Load common code
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$here\common.ps1"

$profilesPath = "$HOME/vsteam_profiles.json"

function Get-VSTeamProfile {
   [CmdletBinding()]
   param(
      # Name is an array so I can pass an array after -Name 
      # I can also use pipe
      [parameter(Mandatory = $false, Position = 1, ValueFromPipelineByPropertyName = $true)]
      [string] $Name
   )

   process {
      if (Test-Path $profilesPath) {
         try {
            # We needed to add ForEach-Object to unroll and show the inner type
            $result = Get-Content $profilesPath | ConvertFrom-Json

            if ($Name) {
               $result = $result | Where-Object Name -eq $Name 
            }

            if ($result) {
               $result | ForEach-Object {
                  # Setting the type lets me format it
                  $_.PSObject.TypeNames.Insert(0, 'Team.Profile')
                  $_ 
               }
            }
         }
         catch {         
            # Catch any error and fail to the return empty array below
            Write-Error "Error ready Profiles file. Use Add-VSTeamProfile to generate new file."
         }
      }
   }
}

function Remove-VSTeamProfile {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Low")]
   param(
      # Name is an array so I can pass an array after -Name 
      # I can also use pipe
      [parameter(Mandatory = $true, Position = 1, ValueFromPipelineByPropertyName = $true)]
      [string[]] $Name,
      [switch] $Force
   )

   begin {
      $profiles = Get-VSTeamProfile
   }

   process {
      foreach ($item in $Name) {
         if ($Force -or $pscmdlet.ShouldProcess($item, "Remove-VSTeamProfile")) {
            # See if this item is already in there
            $profiles = $profiles | Where-Object Name -ne $item
         }
      }
   }

   end {
      $contents = ConvertTo-Json $profiles

      if ([string]::isnullorempty($contents)) {
         $contents = ''
      }
      
      Set-Content -Path $profilesPath -Value $contents
   }
}

function Add-VSTeamProfile {
   [CmdletBinding(DefaultParameterSetName = 'Secure')]
   param(
      [parameter(ParameterSetName = 'Windows', Mandatory = $true, Position = 1)]
      [parameter(ParameterSetName = 'Secure', Mandatory = $true, Position = 1)]
      [Parameter(ParameterSetName = 'Plain')]
      [string] $Account,
      [parameter(ParameterSetName = 'Plain', Mandatory = $true, Position = 2, HelpMessage = 'Personal Access Token')]
      [string] $PersonalAccessToken,
      [parameter(ParameterSetName = 'Secure', Mandatory = $true, HelpMessage = 'Personal Access Token')]
      [securestring] $SecurePersonalAccessToken,
      [string] $Name,
      [ValidateSet('TFS2017', 'TFS2018', 'VSTS')]
      [string] $Version
   )

   DynamicParam {
      # Only add these options on Windows Machines
      if (_isOnWindows) {
         Write-Verbose 'On a Windows machine'
         # Create the dictionary
         $RuntimeParameterDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary

         $ParameterName2 = 'UseWindowsAuthentication'

         # Create the collection of attributes
         $AttributeCollection2 = New-Object System.Collections.ObjectModel.Collection[System.Attribute]

         # Create and set the parameters' attributes
         $ParameterAttribute2 = New-Object System.Management.Automation.ParameterAttribute
         $ParameterAttribute2.Mandatory = $true
         $ParameterAttribute2.ParameterSetName = "Windows"
         $ParameterAttribute2.HelpMessage = "On Windows machines allows you to use the active user identity for authentication. Not available on other platforms."

         # Add the attributes to the attributes collection
         $AttributeCollection2.Add($ParameterAttribute2)

         # Create and return the dynamic parameter
         $RuntimeParameter2 = New-Object System.Management.Automation.RuntimeDefinedParameter($ParameterName2, [switch], $AttributeCollection2)
         $RuntimeParameterDictionary.Add($ParameterName2, $RuntimeParameter2)
         return $RuntimeParameterDictionary
      }
      else {
         Write-Verbose 'Not on a Windows machine'
      }
   }

   process {
      if (_isOnWindows) {
         # Bind the parameter to a friendly variable
         $UsingWindowsAuth = $PSBoundParameters[$ParameterName2]
         if (!($SecurePersonalAccessToken) -and !($PersonalAccessToken) -and !($UsingWindowsAuth)) {
            Write-Error "Personal Access Token must be provided if you are not using Windows Authentication; please see the help."
         }
      }

      if ($SecurePersonalAccessToken) {
         # Convert the securestring to a normal string
         # this was the one technique that worked on Mac, Linux and Windows
         $credential = New-Object System.Management.Automation.PSCredential $account, $SecurePersonalAccessToken
         $_pat = $credential.GetNetworkCredential().Password
      }
      else {
         $_pat = $PersonalAccessToken
      }

      # If they only gave an account name add visualstudio.com
      if ($Account -notlike "*/*") {
         if ($Account -match "(?<protocol>https?\://)?(?<account>[A-Z0-9][-A-Z0-9]*[A-Z0-9])(?<domain>\.visualstudio\.com)?") {
            $Account = "https://$($matches.account).visualstudio.com"
         }
      }

      $authType = "Pat"
      $encodedPat = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes(":$_pat"))

      # If no SecurePersonalAccessToken is entered, and on windows, are we using default credentials for REST calls
      if ((!$_pat) -and (_isOnWindows) -and ($UsingWindowsAuth)) {
         Write-Verbose "Using Default Windows Credentials for authentication; no Personal Access Token required"
         $encodedPat = ""
         $authType = "OnPremise"
      }

      if (-not $Name) {
         $Name = $Account
      }

      # See if this item is already in there
      # I am testing URL because the user may provide a different
      # name and I don't want two with the same URL.
      # The @() forces even 1 item to an array
      $profiles = @(Get-VSTeamProfile | Where-Object URL -ne $Account)

      # Without the Out-Null the original size is showing in output.
      $profiles += [PSCustomObject]@{
         Name    = $Name
         URL     = $Account
         Type    = $authType
         Pat     = $encodedPat
         Version = (_getVSTeamAPIVersion -Instance $Account -Version $Version)
      }

      $contents = ConvertTo-Json $profiles

      Set-Content -Path $profilesPath -Value $contents
   }
}

Set-Alias Get-Profile Get-VSTeamProfile
Set-Alias Add-Profile Add-VSTeamProfile
Set-Alias Remove-Profile Remove-VSTeamProfile

Export-ModuleMember `
   -Function Get-VSTeamProfile, Add-VSTeamProfile, Remove-VSTeamProfile `
   -Alias Get-Profile, Add-Profile, Remove-Profile