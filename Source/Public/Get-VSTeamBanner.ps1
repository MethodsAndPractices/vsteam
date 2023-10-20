function Get-VSTeamBanner {
   [CmdletBinding()]
   param(
      [Parameter(Mandatory = $false)]
      [string]$Id
   )
   process {
      $allBanners = (Invoke-VSTeamRequest -method GET -area 'settings' -resource 'entries/host/GlobalMessageBanners' -version '3.2-preview').value

      if (-not [string]::IsNullOrEmpty($Id)) {
         $filteredBanner = $allBanners[$Id]

         if ($null -eq $filteredBanner) {
            throw "No banner found with ID $Id"
         }

         return $filteredBanner
      }

      return $allBanners
   }
}
