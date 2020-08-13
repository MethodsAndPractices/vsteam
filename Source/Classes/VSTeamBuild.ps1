class VSTeamBuild : VSTeamLeaf {
   [nullable[datetime]] $StartTime
   [string]$Status = $null
   [string]$Result = $null
   [string]$BuildNumber = $null
   [string]$BuildDefinition = $null
   [VSTeamUserEntitlement]$RequestedBy = $null
   [VSTeamUserEntitlement]$RequestedFor = $null
   [VSTeamUserEntitlement]$LastChangedBy = $null

   VSTeamBuild (
      [object]$obj,
      [string]$Projectname
   ) : base($obj.buildNumber, $obj.id.ToString(), $Projectname) {
      $this.Status = $obj.status
      $this.Result = $obj.result
      $this.StartTime = $obj.startTime
      $this.BuildNumber = $obj.buildNumber
      $this.BuildDefinition = $obj.definition.name
      $this.RequestedBy = [VSTeamUserEntitlement]::new($obj.requestedBy, $Projectname)
      $this.RequestedFor = [VSTeamUserEntitlement]::new($obj.requestedFor, $Projectname)
      $this.LastChangedBy = [VSTeamUserEntitlement]::new($obj.lastChangedBy, $Projectname)

      $this._internalObj = $obj

      $this.AddTypeName('Team.Build')
   }
}