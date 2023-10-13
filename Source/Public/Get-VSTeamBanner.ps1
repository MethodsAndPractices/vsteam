function Get-VSTeamBanner {
   [CmdletBinding()]
   param(
      [Parameter(Mandatory = $false)]
      [string]$Id
   )
   process {

      $existingBanners = $null
      if($null -ne $Id){
         $existingBanners = (Invoke-VSTeamRequest -method GET -area 'settings' -resource "entries/host/GlobalMessageBanners/$Id" -version '3.2-preview').value
         if ($null -eq $existingBanners) { throw "No banner found with ID $Id" }
      }else{
         $existingBanners = (Invoke-VSTeamRequest -method GET -area 'settings' -resource "entries/host/GlobalMessageBanners" -version '3.2-preview').value
      }

      return $existingBanners
   }
}
