using namespace Microsoft.PowerShell.SHiPS

[SHiPSProvider(UseCache = $true)]
[SHiPSProvider(BuiltinProgress = $false)]
class VSTeamDescriptor : VSTeamLeaf {

   [string]$Descriptor = $null
   [hashtable]$Links = $null

   VSTeamDescriptor (
      [object]$obj
   ) : base($obj.value, $obj.value, $null) {

      $this.Links = @{
         'Self' = $obj._links.self.href;
         'StorageKey' = $obj._links.storageKey.href;
         'Subject'= $obj._links.subject.href;
      }

      $this.Descriptor = $obj.value

      $this._internalObj = $obj

      $this.AddTypeName('Team.Descriptor')
   }

   [string]ToString() {
      return $this.Descriptor
   }
}