using namespace Microsoft.PowerShell.SHiPS

[SHiPSProvider(UseCache = $true)]
class VSTeamBuildDefinitionProcess : VSTeamDirectory {
   [int]$type
   [string]$yamlFilename
   [VSTeamBuildDefinitionProcessPhase[]]$Phases

   VSTeamBuildDefinitionProcess (
      [object]$obj,
      [string]$Projectname
   ) : base("Process", $Projectname) {

      # Is this a yaml build or not?
      # Type is = 2 for yaml
      $this.type = $obj.type

      if ($this.type -eq 1) {
         foreach ($phase in $obj.phases) {
            $this.Phases += [VSTeamBuildDefinitionProcessPhase]::new($phase, $Projectname)
         }

         $this.AddTypeName('Team.BuildDefinitionPhasedProcess')
      }
      else {
         $this.yamlFilename = $obj.yamlFilename

         $this.DisplayMode = '------'
         $this.AddTypeName('Team.BuildDefinitionYamlProcess')
      }

      $this._internalObj = $obj
   }

   [string]ToString() {
      if ($this.type -eq 1) {
         return "Number of phases: $($this.Phases.Length)"
      }
      else {
         return $this.yamlFilename
      }
   }
}