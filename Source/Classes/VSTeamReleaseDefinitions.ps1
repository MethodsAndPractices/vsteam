using namespace Microsoft.PowerShell.SHiPS

[SHiPSProvider(UseCache = $true)]
[SHiPSProvider(BuiltinProgress = $false)]
class VSTeamReleaseDefinitions : VSTeamDirectory {

   # Default constructor
   VSTeamReleaseDefinitions(
      [string]$Name,
      [string]$ProjectName
   ) : base($Name, $ProjectName) {
      $this.AddTypeName('Team.ReleaseDefinitions')
   }

   [object[]] GetChildItem() {
      $items = Get-VSTeamReleaseDefinition -ProjectName $this.ProjectName | Sort-Object name
      
      $objs = @()

      foreach ($item in $items) {
         $item.AddTypeName('Team.Provider.ReleaseDefinition')

         $objs += $item;
      }

      return $objs
   }
}