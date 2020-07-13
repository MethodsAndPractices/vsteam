using namespace Microsoft.PowerShell.SHiPS

[SHiPSProvider(UseCache = $true)]
[SHiPSProvider(BuiltinProgress = $false)]
class VSTeamExtensions : VSTeamDirectory {

   # Default constructor
   VSTeamExtensions(
      [string]$Name
   ) : base($Name, $null) {
      $this.AddTypeName('Team.Extensions')

      $this.DisplayMode = 'd-r-s-'
   }

   [object[]] GetChildItem() {
      $extensions = Get-VSTeamExtension | Sort-Object name

      $objs = @()

      foreach ($extension in $extensions) {
         $extension.AddTypeName('Team.Provider.Extension')

         $objs += $extension
      }

      return $objs
   }
}