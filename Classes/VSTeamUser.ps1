class VSTeamUser : VSTeamLeaf {
   [string]$DisplayName
   [string]$UniqueName

   VSTeamUser(
      [object]$obj,
      [string]$ProjectName
   ) : base($obj.displayName, $obj.id, $ProjectName) {
      $this.UniqueName = $obj.uniqueName
      $this.DisplayName = $obj.displayName

      $this._internalObj = $obj

      $this.AddTypeName('Team.User')
   }

   [string]ToString() {
      return $this.DisplayName
   }
}