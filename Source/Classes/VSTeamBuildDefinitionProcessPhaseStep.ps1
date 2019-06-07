class VSTeamBuildDefinitionProcessPhaseStep : VSTeamLeaf {
   [bool]$Enabled = $true
   [bool]$ContinueOnError = $false
   [bool]$AlwaysRun = $true
   [int]$TimeoutInMinutes = 0
   [string]$Condition = $null
   [object]$Inputs = $null
   [object]$Task = $null

   VSTeamBuildDefinitionProcessPhaseStep(
      [object]$obj,
      [int]$stepNo,
      [string]$Projectname
   ) : base($obj.displayName, $stepNo.ToString(), $Projectname) {
      $this.Enabled = $obj.enabled
      $this.ContinueOnError = $obj.continueOnError
      $this.AlwaysRun = $obj.alwaysRun
      $this.TimeoutInMinutes = $obj.timeoutInMinutes
      $this.Inputs = $obj.inputs
      $this.Task = $obj.task

      if ($obj.PSObject.Properties.Match('condition').count -gt 0) {
         $this.Condition = $obj.condition
      }

      $this._internalObj = $obj

      $this.AddTypeName('Team.BuildDefinitionProcessPhaseStep')
   }
}