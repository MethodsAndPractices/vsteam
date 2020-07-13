using namespace Microsoft.PowerShell.SHiPS

[SHiPSProvider(UseCache = $true)]
[SHiPSProvider(BuiltinProgress = $false)]
class VSTeamQueues : VSTeamDirectory {

   # Default constructor
   VSTeamQueues(
      [string]$Name,
      [string]$ProjectName
   ) : base($Name, $ProjectName) {
      $this.AddTypeName('Team.Queues')
   }

   [object[]] GetChildItem() {
      $items = Get-VSTeamQueue -ProjectName $this.ProjectName

      foreach ($item in $items) {
         $item.AddTypeName('Team.Provider.Queue')
      }

      return $items
   }
}