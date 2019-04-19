class VSTeamFeed : VSTeamLeaf {
   [string]$description
   [string]$url
   [bool]$upstreamEnabled = $false
   [PSCustomObject]$upstreamSources

   VSTeamFeed (
      [object]$obj
   ) : base($obj.name, $obj.Id, $null) {

      $this.url = $obj.url
      $this.description = $obj.description
      $this.upstreamSources = $obj.upstreamSources

      # These might not be returned
      if ($obj.PSObject.Properties.Match('upstreamEnabled').count -gt 0) {
         $this.upstreamEnabled = $obj.upstreamEnabled
      }

      $this._internalObj = $obj

      $this.AddTypeName('Team.Feed')
   }
}