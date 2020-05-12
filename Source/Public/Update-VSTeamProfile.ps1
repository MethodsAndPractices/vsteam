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

         $vsteamProfile = Get-VSTeamProfile | Where-Object Name -eq $Name

         if ($vsteamProfile) {
            # See if this item is already in there
            # I am testing URL because the user may provide a different
            # name and I don't want two with the same URL.
            # The @() forces even 1 item to an array
            # Now get an array of all profiles but this one and update this one.
            $vsteamProfiles = @(Get-VSTeamProfile | Where-Object Name -ne $Name)

            $newProfile = [PSCustomObject]@{
               Name    = $Name
               URL     = $vsteamProfile.URL
               Type    = $authType
               Pat     = $encodedPat
               Token   = $token
               Version = $vsteamProfile.Version
            }

            $vsteamProfiles += $newProfile

            $contents = ConvertTo-Json $vsteamProfiles

            Set-Content -Path $profilesPath -Value $contents
         }
         else {
            # This will happen when they don't have any profiles.
            Write-Warning 'Profile not found'
         }
      }
   }
}