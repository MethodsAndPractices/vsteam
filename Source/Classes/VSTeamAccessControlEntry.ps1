using namespace Microsoft.PowerShell.SHiPS

[SHiPSProvider(UseCache = $true)]
[SHiPSProvider(BuiltinProgress = $false)]
class VSTeamAccessControlEntry : VSTeamLeaf {
   [string]$Descriptor = $null
   [int]$Allow = 0
   [int]$Deny = 0
   [hashtable]$ExtendedInfo = @{}

   VSTeamAccessControlEntry (
      [object]$obj
   ) : base($obj.descriptor, $obj.descriptor, $null) {
      $this.Descriptor = $obj.descriptor
      $this.Allow = $obj.allow
      $this.Deny = $obj.deny

      if ([bool]($obj.PSobject.Properties.name -match "extendedInfo"))
      {
         $this.ExtendedInfo = $obj.extendedInfo
      }

      $this._internalObj = $obj

      $this.AddTypeName('Team.AccessControlEntry')
   }

   [string]ToString() {
      return "Descriptor=$($this.Descriptor); Allow=$($this.Allow); Deny=$($this.Deny); ExtendedInfo=$($this.ExtendedInfo)"
   }
}