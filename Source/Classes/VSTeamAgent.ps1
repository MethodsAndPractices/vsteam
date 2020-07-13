class VSTeamAgent : VSTeamDirectory {
   [string]$version
   [string]$status
   [string]$os
   [bool]$enabled
   [int]$poolId
   [int]$agentId
   [PSCustomObject]$systemCapabilities

   VSTeamAgent (
      [object]$obj,
      [int]$poolId
   ) : base($obj.name, $null) {

      $this.poolId = $poolId
      $this.agentId = $obj.Id
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

   [object[]] GetChildItem() {
      $jobRequests = Get-VSTeamJobRequest -PoolId $this.poolId -AgentId $this.agentId

      $objs = @()

      foreach ($item in $jobRequests) {
         $item.AddTypeName('Team.Provider.JobRequest')

         $objs += $item
      }

      return $objs
   }
}