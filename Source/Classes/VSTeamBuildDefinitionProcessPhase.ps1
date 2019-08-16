class VSTeamBuildDefinitionProcessPhase : VSTeamDirectory {
   [string]$Condition = $null
   [object]$Target = $null
   [string]$JobAuthorizationScope = $null
   [int]$JobCancelTimeoutInMinutes = -1
   [VSTeamBuildDefinitionProcessPhaseStep[]] $Steps
   [int]$StepCount = 0

   VSTeamBuildDefinitionProcessPhase(
      [object]$obj,
      [string]$Projectname
   ) : base($obj.name, $Projectname) {
      $this.Target = $obj.target
      $this.JobAuthorizationScope = $obj.jobAuthorizationScope

      # These might not be returned
      if ($obj.PSObject.Properties.Match('condition').count -gt 0) {
         $this.Condition = $obj.condition
      }
	  
      # As of version 5.0 of the REST API this has moved to the Build Def
      if ($obj.PSObject.Properties.Match('jobCancelTimeoutInMinutes').count -gt 0) {
         $this.JobCancelTimeoutInMinutes = $obj.jobCancelTimeoutInMinutes
      }

      $this.StepCount = 0
      if ( $obj.PSObject.Properties.name -match 'steps' ) {
         foreach ($step in $obj.steps) {
            $this.StepCount++
            $this.Steps += [VSTeamBuildDefinitionProcessPhaseStep]::new($step, $this.StepCount, $Projectname)
         }
      }

      $this._internalObj = $obj

      $this.AddTypeName('Team.BuildDefinitionProcessPhase')
   }

   [object[]] GetChildItem() {
      return $this.Steps
   }
}
