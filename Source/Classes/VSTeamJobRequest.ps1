class VSTeamJobRequest : VSTeamLeaf {
   [datetime] $QueueTime
   [nullable[datetime]] $AssignTime
   [nullable[datetime]] $StartTime
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
      if ($obj.PSobject.Properties.Name -notcontains "result" -and $obj.PSobject.Properties.Name -notcontains "assignTime") {
         $this.Result = 'queued'
      }
      elseif ($obj.PSobject.Properties.Name -notcontains "result" -and $obj.PSobject.Properties.Name -contains "assignTime") {
         $this.Result = 'running'
      }
      else {
        $this.Result = $obj.result
      } 
      $this.Demands = $obj.demands
      $this.QueueTime = $obj.queueTime
      if ($obj.PSobject.Properties.Name -contains "assignTime") {
         $this.AssignTime = $obj.assignTime
      }
      else {
         $this.AssignTime = $null
      }
      if ($obj.PSobject.Properties.Name -contains "receiveTime") {
         $this.StartTime = $obj.receiveTime
      }
      else {
         $this.StartTime = $null
      }
      if ($obj.PSobject.Properties.Name -contains "finishTime") {
         $this.FinishTime = $obj.finishTime
      }
      else {
         $this.FinishTime = $null
      }
      $this.Pipeline = $obj.definition.name
      if ($null -ne $this.FinishTime -and $null -ne $this.StartTime) {
         $this.Duration = $this.FinishTime - $this.StartTime
      }
      $this._internalObj = $obj
      $this.AddTypeName('Team.JobRequest')
   }
}
