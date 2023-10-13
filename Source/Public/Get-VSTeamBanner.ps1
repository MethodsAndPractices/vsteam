function Get-VSTeamBanner {
   [CmdletBinding()]
   param(
      [Parameter(Mandatory = $true)]
      [string]$Id
   )
   process {

      $existingBanner = (Invoke-VSTeamRequest -method GET -area 'settings' -resource "entries/host/GlobalMessageBanners/$Id" -version '3.2-preview').value
      if ($null -eq $existingBanner) { throw "No banner found with ID $Id" }

      return $existingBanner
   }
}