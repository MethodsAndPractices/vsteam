using namespace Microsoft.PowerShell.SHiPS

[SHiPSProvider(UseCache = $true)]
[SHiPSProvider(BuiltinProgress = $false)]
class VSTeamQueue : VSTeamLeaf {

   [string]$poolName
   [VSTeamPool]$pool

   # Default constructor
   VSTeamQueue(
      [object]$obj,
      [string]$Projectname
   ) : base($obj.name, $obj.id, $Projectname) {

      # pool values are not returned always
      if ($obj.PSObject.Properties.Match('poolName').count -gt 0) {
         $this.poolName = $obj.poolName
      }

      if ($obj.PSObject.Properties.Match('pool').count -gt 0) {
         $this.pool = [VSTeamPool]::new($obj.pool)
         $this.poolName = $obj.pool.name
      }

      $this.AddTypeName('Team.Queue')

      $this._internalObj = $obj
   }
}