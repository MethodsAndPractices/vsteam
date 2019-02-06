class VSTeamTeam : VSTeamLeaf {
   [string]$Description = $null

   VSTeamTeam (
      [object]$obj,
      [string]$ProjectName
   ) : base($obj.name, $obj.Id, $ProjectName) {
      $this.Description = $obj.Description

      $this._internalObj = $obj

      $this.AddTypeName('Team.Team')
   }
}