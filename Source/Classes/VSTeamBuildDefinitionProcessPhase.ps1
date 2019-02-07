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
      $this.Condition = $obj.condition
      $this.Target = $obj.target
      $this.JobAuthorizationScope = $obj.jobAuthorizationScope
      $this.JobCancelTimeoutInMinutes = $obj.jobCancelTimeoutInMinutes

      $this.StepCount = 0
      foreach ($step in $obj.steps) {
         $this.StepCount++
         $this.Steps += [VSTeamBuildDefinitionProcessPhaseStep]::new($step, $this.StepCount, $Projectname)
      }

      $this._internalObj = $obj

      $this.AddTypeName('Team.BuildDefinitionProcessPhase')
   }

   [object[]] GetChildItem() {
      return $this.Steps
   }
}