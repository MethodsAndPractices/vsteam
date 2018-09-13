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

                  if ($_.PSObject.Properties.Match('Token').count -eq 0) {
                     # This is a profile that was created before the module supported
                     # bearer tokens. The rest of the module expects there to be a Token
                     # property.  Add one with a value of ''
                     $_ | Add-Member NoteProperty 'Token' ''
                  }

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
      [string] $Version,

      [switch] $UseBearerToken
   )

   DynamicParam {
      # Only add these options on Windows Machines
      if (_isOnWindows) {
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
   }

   process {

      if ($SecurePersonalAccessToken) {
         # Even when promoted for a Secure Personal Access Token you can just
         # press enter. This leads to an empty PAT so error below.

         # Convert the securestring to a normal string
         # this was the one technique that worked on Mac, Linux and Windows
         $_pat = _convertSecureStringTo_PlainText -SecureString $SecurePersonalAccessToken
      }
      else {
         $_pat = $PersonalAccessToken
      }

      if (_isOnWindows) {
         # Bind the parameter to a friendly variable
         $UsingWindowsAuth = $PSBoundParameters[$ParameterName2]
         if (!($_pat) -and !($UsingWindowsAuth)) {
            Write-Error 'Personal Access Token must be provided if you are not using Windows Authentication; please see the help.'
            return
         }
      }

      # If they only gave an account name add https://dev.azure.com
      if ($Account -notlike "*/*") {
         if ($Account -match "(?<protocol>https?\://)?(?<domain>dev\.azure\.com/)?(?<account>[A-Z0-9][-A-Z0-9]*[A-Z0-9])") {
            $Account = "https://dev.azure.com/$($matches.account)"
         }
      }
      if ($Account -match "(?<protocol>https?\://)?(?<account>[A-Z0-9][-A-Z0-9]*[A-Z0-9])(?<domain>\.visualstudio\.com)") {
         $Account = "https://dev.azure.com/$($matches.account)"
      }

      if ($UseBearerToken.IsPresent) {
         $authType = 'Bearer'
         $token = $_pat
         $encodedPat = ''
      }
      else {
         $token = ''
         $authType = 'Pat'
         $encodedPat = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes(":$_pat"))
      }

      # If no SecurePersonalAccessToken is entered, and on windows, are we using default credentials for REST calls
      if ((!$_pat) -and (_isOnWindows) -and ($UsingWindowsAuth)) {
         Write-Verbose 'Using Default Windows Credentials for authentication; no Personal Access Token required'
         $encodedPat = ''
         $token = ''
         $authType = 'OnPremise'
      }

      if (-not $Name) {
         $Name = $Account
      }

      # See if this item is already in there
      # I am testing URL because the user may provide a different
      # name and I don't want two with the same URL.
      # The @() forces even 1 item to an array
      $profiles = @(Get-VSTeamProfile | Where-Object URL -ne $Account)

      $newProfile = [PSCustomObject]@{
         Name    = $Name
         URL     = $Account
         Type    = $authType
         Pat     = $encodedPat
         Token   = $token
         Version = (_getVSTeamAPIVersion -Instance $Account -Version $Version)
      }

      $profiles += $newProfile

      $contents = ConvertTo-Json $profiles

      Set-Content -Path $profilesPath -Value $contents
   }
}

function Update-VSTeamProfile {
   [CmdletBinding(DefaultParameterSetName = 'Secure', SupportsShouldProcess = $true, ConfirmImpact = "Medium")]
   param(
      [parameter(ParameterSetName = 'Plain', Mandatory = $true, HelpMessage = 'Personal Access Token')]
      [string] $PersonalAccessToken,

      [parameter(ParameterSetName = 'Secure', Mandatory = $true, HelpMessage = 'Personal Access Token')]
      [securestring] $SecurePersonalAccessToken,

      [switch] $Force
   )

   DynamicParam {
      # Create the dictionary
      $RuntimeParameterDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary

      $profileArrSet = Get-VSTeamProfile | Select-Object -ExpandProperty Name

      if ($profileArrSet) {
         $profileParam = _buildDynamicParam -ParameterName 'Name' -Mandatory $true -Position 0 -arrSet $profileArrSet
      }
      else {
         $profileParam = _buildDynamicParam -ParameterName 'Name' -Mandatory $true -Position 0
      }

      $RuntimeParameterDictionary.Add('Name', $profileParam)

      return $RuntimeParameterDictionary
   }

   process {
      $Name = $PSBoundParameters['Name']

      if ($Force -or $pscmdlet.ShouldProcess($Name, "Update-VSTeamProfile")) {
         if ($SecurePersonalAccessToken) {
            # Even when promoted for a Secure Personal Access Token you can just
            # press enter. This leads to an empty PAT so error below.

            # Convert the securestring to a normal string
            # this was the one technique that worked on Mac, Linux and Windows
            $_pat = _convertSecureStringTo_PlainText -SecureString $SecurePersonalAccessToken
         }
         else {
            $_pat = $PersonalAccessToken
         }

         $token = ''
         $authType = 'Pat'
         $encodedPat = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes(":$_pat"))

         $profile = Get-VSTeamProfile | Where-Object Name -eq $Name

         if ($profile) {
            # See if this item is already in there
            # I am testing URL because the user may provide a different
            # name and I don't want two with the same URL.
            # The @() forces even 1 item to an array
            # Now get an array of all profiles but this one and update this one.
            $profiles = @(Get-VSTeamProfile | Where-Object Name -ne $Name)

            $newProfile = [PSCustomObject]@{
               Name    = $Name
               URL     = $profile.URL
               Type    = $authType
               Pat     = $encodedPat
               Token   = $token
               Version = $profile.Version
            }

            $profiles += $newProfile

            $contents = ConvertTo-Json $profiles

            Set-Content -Path $profilesPath -Value $contents
         }
         else {
            # This will happen when they don't have any profiles. 
            Write-Warning 'Profile not found'
         }
      }
   }
}

Set-Alias Get-Profile Get-VSTeamProfile
Set-Alias Add-Profile Add-VSTeamProfile
Set-Alias Remove-Profile Remove-VSTeamProfile
Set-Alias Update-Profile Update-VSTeamProfile

Export-ModuleMember `
   -Function Get-VSTeamProfile, Add-VSTeamProfile, Remove-VSTeamProfile, Update-VSTeamProfile `
   -Alias Get-Profile, Add-Profile, Remove-Profile, Update-Profile