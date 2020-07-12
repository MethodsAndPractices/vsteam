using namespace Microsoft.PowerShell.SHiPS

[SHiPSProvider(UseCache = $true)]
class VSTeamTeams : VSTeamDirectory {
   VSTeamTeams(
      [string]$Name,
      [string]$ProjectName
   ) : base($Name, $ProjectName) {
      $this.AddTypeName('Team.Teams')
   }

   [object[]] GetChildItem() {
      $items = Get-VSTeam -ProjectName $this.ProjectName

      foreach ($item in $items) {
         $item.AddTypeName('Team.Provider.Team')
      }

      return $items
   }
}