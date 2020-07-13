using namespace Microsoft.PowerShell.SHiPS

[SHiPSProvider(UseCache = $true)]
[SHiPSProvider(BuiltinProgress = $false)]
class VSTeamPool : VSTeamDirectory {

   [int]$id
   [bool]$isHosted = $false
   [VSTeamUserEntitlement]$owner = $null
   [VSTeamUserEntitlement]$CreatedBy = $null

   # The number of agents in the pool
   [int]$count

   # Default constructor
   VSTeamPool(
      [object]$obj
   ) : base($obj.Name, $null) {

      $this.id = $obj.id

      # values are not returned always
      if ($obj.PSObject.Properties.Match('isHosted').count -gt 0) {
         $this.isHosted = $obj.isHosted
      }

      if ($obj.PSObject.Properties.Match('size').count -gt 0) {
         $this.count = $obj.size
      }

      # On some accounts the CreatedBy is null for hosted pools
      if ($obj.PSObject.Properties.Match('createdBy').count -gt 0 -and
         $null -ne $obj.createdBy) {
         $this.CreatedBy = [VSTeamUserEntitlement]::new($obj.createdBy, $null)
      }

      # Depending on TFS/VSTS this might not be returned
      # Just becaues it exisit does not mean it is not $null
      if ($obj.PSObject.Properties.Match('owner').count -gt 0 -and
          $null -ne $obj.owner) {
         $this.owner = [VSTeamUserEntitlement]::new($obj.owner, $null)
      }

      $this.AddTypeName('Team.Pool')

      if ($this.isHosted) {
         $this.DisplayMode = 'd-r-s-'
      }
      else {
         $this.DisplayMode = 'd-----'
      }

      $this._internalObj = $obj
   }

   [object[]] GetChildItem() {
      $agents = Get-VSTeamAgent -PoolId $this.id

      $objs = @()

      foreach ($agent in $agents) {
         $agent.AddTypeName('Team.Provider.Agent')

         $objs += $agent
      }

      return $objs
   }
}