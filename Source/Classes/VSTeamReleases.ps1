using namespace Microsoft.PowerShell.SHiPS

[SHiPSProvider(UseCache = $true)]
[SHiPSProvider(BuiltinProgress = $false)]
class VSTeamReleases : VSTeamDirectory {

   VSTeamReleases(
      [string]$Name,
      [string]$ProjectName
   ) : base($Name, $ProjectName) {
      $this.AddTypeName('Team.Releases')
   }

   [object[]] GetChildItem() {
      $releases = Get-VSTeamRelease -ProjectName $this.ProjectName -Expand Environments

      $objs = @()

      foreach ($release in $releases) {
         $item = [VSTeamRelease]::new(
            $release,
            $this.ProjectName)

         $item.AddTypeName('Team.Provider.Release')

         $objs += $item
      }

      return $objs
   }
}