using namespace Microsoft.PowerShell.SHiPS

[SHiPSProvider(UseCache = $true)]
[SHiPSProvider(BuiltinProgress = $false)]
class VSTeamGroup : VSTeamLeaf {

   [string]$SubjectKind = $null
   [string]$Description = $null
   [string]$Domain = $null
   [string]$PrincipalName = $null
   [string]$MailAddress = $null
   [string]$Origin = $null
   [string]$OriginID = $null
   [string]$DisplayName = $null
   [string]$URL = $null
   [string]$Descriptor = $null
   [hashtable]$Links = $null

   VSTeamGroup (
      [object]$obj
   ) : base($obj.displayName, $obj.descriptor, $null) {
      $this.SubjectKind = $obj.subjectKind
      $this.Description = $obj.description
      $this.Domain = $obj.domain
      $this.PrincipalName = $obj.principalName
      $this.MailAddress = $obj.mailAddress
      $this.Origin = $obj.origin
      $this.OriginID = $obj.originId
      $this.DisplayName = $obj.displayName
      $this.ProjectName = $obj.principalName.Split('\')[0].Trim('[',']')

      $this.Links = @{
         'Self' = $obj._links.self.href;
         'Memberships' = $obj._links.memberships.href;
         'MembershipState'= $obj._links.membershipState.href;
         'StorageKey'= $obj._links.storageKey.href;
      }

      $this.URL = $obj.url
      $this.Descriptor = $obj.descriptor

      $this._internalObj = $obj

      $this.AddTypeName('Team.Group')
   }

   [string]ToString() {
      return $this.PrincipalName
   }
}