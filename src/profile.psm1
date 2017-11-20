Set-StrictMode -Version Latest

# Load common code
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$here\common.ps1"

function Get-VSTeamProfile {
   if (Test-Path "$HOME/profiles.json") {
      try {
         Get-Content "$HOME/profiles.json" | ConvertFrom-Json  
      }
      catch {
         return '[]' | ConvertFrom-Json   
      }
   }
   else {
      return '[]' | ConvertFrom-Json
   }
}


Set-Alias Get-Profile Get-VSTeamProfile
Set-Alias Add-Profile Add-VSTeamProfile
Set-Alias Remove-Profile Remove-VSTeamProfile

Export-ModuleMember `
   -Function Get-VSTeamProfile, Add-VSTeamProfile, Remove-VSTeamProfile `
   -Alias Get-Profile, Add-Profile, Remove-Profile