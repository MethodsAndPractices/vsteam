using namespace Microsoft.PowerShell.SHiPS

[SHiPSProvider(UseCache = $true)]
[SHiPSProvider(BuiltinProgress = $false)]
class VSTeamPools : VSTeamDirectory {

   # Default constructor
   VSTeamPools(
      [string]$Name
   ) : base($Name, $null) {
      $this.AddTypeName('Team.Pools')

      $this.DisplayMode = 'd-r-s-'
   }

   [object[]] GetChildItem() {
      $pools = Get-VSTeamPool | Sort-Object name

      $objs = @()

      foreach ($pool in $pools) {
         $pool.AddTypeName('Team.Provider.Pool')

         $objs += $pool
      }

      return $objs
   }
}