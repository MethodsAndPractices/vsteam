using namespace Microsoft.PowerShell.SHiPS

[SHiPSProvider(UseCache = $true)]
[SHiPSProvider(BuiltinProgress = $false)]
class VSTeamGroups : VSTeamDirectory {

   # Default constructor
   VSTeamGroups(
      [string]$Name
   ) : base($Name, $null) {
      $this.AddTypeName('Team.Groups')

      $this.DisplayMode = 'd-r-s-'
   }

   [object[]] GetChildItem() {
      $Groups = Get-VSTeamGroup -ErrorAction SilentlyContinue | Sort-Object name

      $objs = @()

      foreach ($Group in $Groups) {
         $Group.AddTypeName('Team.Provider.Group')

         $objs += $Group
      }

      return $objs
   }
}