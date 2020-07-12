using namespace Microsoft.PowerShell.SHiPS

[SHiPSProvider(UseCache = $false)]
class VSTeamTeams : VSTeamDirectory {
   VSTeamTeams(
      [string]$Name,
      [string]$ProjectName
   ) : base($Name, $ProjectName) {
      $this.AddTypeName('Team.Teams')
   }

   [object[]] GetChildItem() {
      Write-Verbose "Project: $($this.ProjectName)"
      
      $items = Get-VSTeam -ProjectName $this.ProjectName

      foreach ($item in $items) {
         $item.AddTypeName('Team.Provider.Team')
      }

      return $items
   }
}