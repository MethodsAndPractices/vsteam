function Remove-VSTeamBanner {
   [CmdletBinding()]
   param(
      [Parameter(Mandatory = $true)]
      [string]$Id
   )
   process {
      Invoke-VSTeamRequest -method DELETE -area 'settings' -resource "entries/host/GlobalMessageBanners/$Id" -version '3.2-preview'
   }
}