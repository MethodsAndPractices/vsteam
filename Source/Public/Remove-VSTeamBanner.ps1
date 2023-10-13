function Remove-VSTeamBanner {
   [CmdletBinding(SupportsShouldProcess=$true)]
   param(
      [Parameter(Mandatory = $true)]
      [string]$Id
   )
   process {
      if ($PSCmdlet.ShouldProcess("Removing banner with ID $Id")) {
         Invoke-VSTeamRequest -method DELETE -area 'settings' -resource "entries/host/GlobalMessageBanners/$Id" -version '3.2-preview'
      }
   }
}