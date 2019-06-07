using namespace Microsoft.PowerShell.SHiPS

[SHiPSProvider(UseCache = $true)]
[SHiPSProvider(BuiltinProgress = $false)]
class VSTeamSecurityNamespace : VSTeamLeaf {
   [string]$DisplayName = $null
   [string]$SeparatorValue = $null
   [int]$ElementLength = 0
   [int]$WritePermission = 0
   [int]$ReadPermission = 0
   [string]$DataspaceCategory = $null
   [string]$StructureValue = $null
   [string]$ExtensionType = $null
   [bool]$IsRemotable = $false
   [bool]$UseTokenTranslator = $false
   [int]$SystemBitMask = 0
   [hashtable[]]$Actions

   VSTeamSecurityNamespace (
      [object]$obj
   ) : base($obj.name, $obj.namespaceId, $null) {
      $this.Name = $obj.name
      $this.ID = $obj.namespaceId
      $this.DisplayName = $obj.displayName
      $this.SeparatorValue = $obj.separatorValue
      $this.ElementLength = $obj.elementLength
      $this.WritePermission = $obj.writePermission
      $this.ReadPermission = $obj.readPermission
      $this.DataspaceCategory = $obj.dataspaceCategory
      $this.StructureValue = $obj.structureValue
      $this.ExtensionType = $obj.extensionType
      $this.IsRemotable = $obj.isRemotable
      $this.UseTokenTranslator = $obj.useTokenTranslator
      $this.SystemBitMask = $obj.systemBitMask

      $this.Actions = @()
      foreach($action in $obj.actions)
      {
         $subAction = @{}
         $subAction.Bit = $action.bit
         $subAction.Name = $action.name
         $subAction.DisplayName = $action.displayName
         $this.Actions += $subAction
      }

      $this._internalObj = $obj

      $this.AddTypeName('Team.SecurityNamespace')
   }

   [string]ToString() {
      return $this.Name
   }
}