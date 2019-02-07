class VSTeamTask : VSTeamLeaf {
   [string]$LogURL = $null
   [string]$Status = $null

   VSTeamTask (
      [object]$obj,
      [string]$ProjectName
   ) : base($obj.Name, $obj.id, $ProjectName) {
      $this.LogURL = $obj.logUrl
      $this.Status = $obj.status

      $this._internalObj = $obj

      $this.AddTypeName('Team.Task')
   }
}