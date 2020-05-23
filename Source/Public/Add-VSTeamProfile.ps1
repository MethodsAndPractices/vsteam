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

      [ValidateSet('TFS2017', 'TFS2018', 'AzD2019', 'VSTS', 'AzD', 'TFS2017U1', 'TFS2017U2', 'TFS2017U3', 'TFS2018U1', 'TFS2018U2', 'TFS2018U3', 'AzD2019U1')]
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
         if (-not $Name) {
            $Name = $Account
         }
         $Account = "https://dev.azure.com/$($Account)"
      }
      # If they gave https://dev.azure.com extract Account and Profile name
      if ($Account -match "(?<protocol>https\://)?(?<domain>dev\.azure\.com/)(?<account>[A-Z0-9][-A-Z0-9]*[A-Z0-9])") {
         if (-not $Name) {
            $Name = $matches.account
         }
         $Account = "https://dev.azure.com/$($matches.account)"
      }
      # If they gave https://xxx.visualstudio.com extract Account and Profile name, convert to new URL
      if ($Account -match "(?<protocol>https?\://)?(?<account>[A-Z0-9][-A-Z0-9]*[A-Z0-9])(?<domain>\.visualstudio\.com)") {
         if (-not $Name) {
            $Name = $matches.account
         }
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