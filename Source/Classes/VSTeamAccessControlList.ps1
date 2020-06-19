using namespace Microsoft.PowerShell.SHiPS

[SHiPSProvider(UseCache = $true)]
[SHiPSProvider(BuiltinProgress = $false)]
class VSTeamAccessControlList : VSTeamLeaf {
   [string]$Token = $null
   [bool]$InheritPermissions = $false
   [hashtable]$Aces = @{}

   VSTeamAccessControlList (
      [object]$obj
   ) : base($obj.token, $obj.token, $null) {
      $this.Token = $obj.token
      $this.InheritPermissions = $obj.inheritPermissions
      
      $props = Get-Member -InputObject $obj.acesDictionary -MemberType NoteProperty

      foreach($prop in $props) {
         $propValue = $obj.acesDictionary | Select-Object -ExpandProperty $prop.Name
         $aceObject = [VSTeamAccessControlEntry]::new($propValue)
         $this.Aces[$aceObject.Descriptor] = $aceObject
      }

      $this._internalObj = $obj

      $this.AddTypeName('Team.AccessControlList')
   }

   [string]ToString() {
      return $this.Token
   }
}