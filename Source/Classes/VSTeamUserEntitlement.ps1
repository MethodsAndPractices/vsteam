class VSTeamUserEntitlement : VSTeamLeaf {
   [string]$DisplayName
   [string]$UniqueName

   VSTeamUserEntitlement(
      [object]$obj,
      [string]$ProjectName
   ) : base($obj.displayName, $obj.id, $ProjectName) {
      $this.UniqueName = $obj.uniqueName
      $this.DisplayName = $obj.displayName

      $this._internalObj = $obj

      $this.AddTypeName('Team.UserEntitlement')
   }

   [string]ToString() {
      return $this.DisplayName
   }
}