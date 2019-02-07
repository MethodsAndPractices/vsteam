class VSTeamBuild : VSTeamLeaf {
   [datetime]$StartTime
   [string]$Status = $null
   [string]$Result = $null
   [string]$BuildNumber = $null
   [string]$BuildDefinition = $null
   [VSTeamUser]$RequestedBy = $null
   [VSTeamUser]$RequestedFor = $null
   [VSTeamUser]$LastChangedBy = $null

   VSTeamBuild (
      [object]$obj,
      [string]$Projectname
   ) : base($obj.buildNumber, $obj.id.ToString(), $Projectname) {
      $this.Status = $obj.status
      $this.Result = $obj.result
      $this.StartTime = $obj.startTime
      $this.BuildNumber = $obj.buildNumber
      $this.BuildDefinition = $obj.definition.name
      $this.RequestedBy = [VSTeamUser]::new($obj.requestedBy, $Projectname)
      $this.RequestedFor = [VSTeamUser]::new($obj.requestedFor, $Projectname)
      $this.LastChangedBy = [VSTeamUser]::new($obj.lastChangedBy, $Projectname)

      $this._internalObj = $obj

      $this.AddTypeName('Team.Build')
   }
}