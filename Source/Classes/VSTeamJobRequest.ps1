class VSTeamJobRequest : VSTeamLeaf {
   [datetime] $QueueTime
   [datetime] $AssignTime
   [datetime] $StartTime
   [nullable[datetime]] $FinishTime
   [timespan] $Duration
   [string] $Type
   [string] $Result
   [string[]] $Demands
   [string] $Pipeline
   
   VSTeamJobRequest (
      [object]$obj
   ) : base($obj.owner.name, $obj.requestId, $null) {

      $this.Type = $obj.planType
      if($obj.PSobject.Properties.Name -contains "result") {
         $this.Result = $obj.result
      } else { $this.Result = 'running' }
      $this.Demands = $obj.demands
      $this.QueueTime = $obj.queueTime
      $this.AssignTime = $obj.assignTime
      $this.StartTime = $obj.receiveTime
      if($obj.PSobject.Properties.Name -contains "finishTime") {
         $this.FinishTime = $obj.finishTime
      } else { $this.FinishTime = $null }
      $this.Pipeline = $obj.definition.name

      if($null -ne $this.FinishTime) {
         $this.Duration = $this.FinishTime - $this.StartTime
      }

      $this._internalObj = $obj

      $this.AddTypeName('Team.JobRequest')
   }
}
