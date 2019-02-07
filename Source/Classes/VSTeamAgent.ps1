class VSTeamAgent : VSTeamLeaf {
   [string]$version
   [string]$status
   [string]$os
   [bool]$enabled
   [PSCustomObject]$systemCapabilities

   VSTeamAgent (
      [object]$obj
   ) : base($obj.name, $obj.Id, $null) {

      $this.status = $obj.status
      $this.enabled = $obj.enabled
      $this.version = $obj.version
      $this.systemCapabilities = $obj.systemCapabilities

      # Depending on TFS/VSTS this might not be returned
      if ($obj.PSObject.Properties.Match('osDescription').count -gt 0) {
         $this.os = $obj.osDescription
      }

      $this._internalObj = $obj

      $this.AddTypeName('Team.Agent')
   }
}