class VSTeamJobRequest : VSTeamLeaf {
   [datetime] $QueueTime
   [datetime] $AssignTime
   [datetime] $StartTime
   [datetime] $FinishTime
   [timespan] $Duration
   [string] $Type
   [string] $Result
   [string[]] $Demands
   [string] $Pipeline
   
   VSTeamJobRequest (
      [object]$obj
   ) : base($obj.owner.name, $obj.requestId, $null) {

      $this.Type = $obj.planType
      $this.Result = $obj.result
      $this.Demands = $obj.demands
      $this.QueueTime = $obj.queueTime
      $this.AssignTime = $obj.assignTime
      $this.StartTime = $obj.receiveTime
      $this.FinishTime = $obj.finishTime
      $this.Pipeline = $obj.definition.name

      if($null -ne $this.FinishTime) {
         $this.Duration = $this.FinishTime - $this.StartTime
      }

      $this._internalObj = $obj

      $this.AddTypeName('Team.JobRequest')
   }
}