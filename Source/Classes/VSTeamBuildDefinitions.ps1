using namespace Microsoft.PowerShell.SHiPS

[SHiPSProvider(UseCache = $true)]
[SHiPSProvider(BuiltinProgress = $false)]
class VSTeamBuildDefinitions : VSTeamDirectory {

   # Default constructor
   VSTeamBuildDefinitions(
      [string]$Name,
      [string]$ProjectName
   ) : base($Name, $ProjectName) {
      $this.AddTypeName('Team.BuildDefinitions')
   }

   [object[]] GetChildItem() {
      $items = Get-VSTeamBuildDefinition -ProjectName $this.ProjectName

      foreach ($item in $items) {
         $item.AddTypeName('Team.Provider.BuildDefinition')

         # This has to be done here becuase this is the only point
         # we know if the object graph is for the provider or not.
         if ($item._internalObj.PSObject.Properties.Match('process').count -gt 0) {
            if ($item.Process.type -eq 1) {
               $item.Process.AddTypeName('Team.Provider.BuildDefinitionPhasedProcess')
               foreach ($phase in $item.Process.phases) {
                  $phase.AddTypeName('Team.Provider.BuildDefinitionProcessPhase')

                  foreach ($step in $phase.steps) {
                     $step.AddTypeName('Team.Provider.BuildDefinitionProcessPhaseStep')
                  }
               }
            }
            else {
               $item.Process.AddTypeName('Team.Provider.BuildDefinitionProcess')
            }
         }


         # TFS
         if ($item._internalObj.PSObject.Properties.Match('build').count -gt 0) {
            foreach ($step in $item.Steps) {
               $step.AddTypeName('Team.Provider.BuildDefinitionProcessPhaseStep')
            }
         }
      }

      return $items
   }
}