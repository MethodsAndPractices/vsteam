using namespace Microsoft.PowerShell.SHiPS

[SHiPSProvider(UseCache = $true)]
[SHiPSProvider(BuiltinProgress = $false)]
class VSTeamBuilds : VSTeamDirectory {

   # Default constructor
   VSTeamBuilds(
      [string]$Name,
      [string]$ProjectName
   ) : base($Name, $ProjectName) {
      $this.AddTypeName('Team.Builds')
   }

   [object[]] GetChildItem() {
      $builds = Get-VSTeamBuild -ProjectName $this.ProjectName

      $objs = @()

      foreach ($build in $builds) {
         $item = [VSTeamBuild]::new(
            $build,
            $build.project.name)

         $item.AddTypeName('Team.Provider.Build')

         $objs += $item
      }

      return $objs
   }
}