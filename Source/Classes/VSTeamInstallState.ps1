class VSTeamInstallState {
   [string]$flags
   [string]$lastUpdated
   # The object returned from the REST API call
   [object] hidden $_internalObj = $null

   VSTeamInstallState(
      [object]$obj
   ) {

      $this.flags = $obj.flags
      $this.lastUpdated = $obj.lastUpdated

      $this._internalObj = $obj

      $this.PSObject.TypeNames.Insert(0, 'Team.InstallState')
   }

   [string]ToString() {
         return "Flags: $($this.flags), Last Updated: $($this.lastUpdated)"
   }
}