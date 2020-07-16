using namespace Microsoft.PowerShell.SHiPS

[SHiPSProvider(UseCache = $true)]
class VSTeamRepositories : VSTeamDirectory {

   # Default constructor
   VSTeamRepositories(
      [string]$Name,
      [string]$ProjectName
   ) : base($Name, $ProjectName) {
      $this.AddTypeName('Team.Repositories')
   }

   [object[]] GetChildItem() {
      $items = Get-VSTeamGitRepository -ProjectName $this.ProjectName

      foreach ($item in $items) {
         $item.AddTypeName('Team.Provider.Repository')
      }

      return $items
   }
}