using namespace Microsoft.PowerShell.SHiPS

[SHiPSProvider(UseCache = $true)]
[SHiPSProvider(BuiltinProgress = $false)]
class VSTeamUser2 : VSTeamLeaf {

   [string]$SubjectKind = $null
   #[string]$CUID = $null
   [string]$Domain = $null
   [string]$PrincipalName = $null
   [string]$MailAddress = $null
   [string]$Origin = $null
   [string]$OriginID = $null
   [string]$DisplayName = $null
   [string]$URL = $null
   [string]$Descriptor = $null
   [hashtable]$Links = $null
   [string]$MetaType = $null

   VSTeamUser2 (
      [object]$obj
   ) : base($obj.displayName, $obj.descriptor, $null) {
      $this.SubjectKind = $obj.subjectKind
      #$this.CUID = $obj.cuid
      $this.Domain = $obj.domain
      $this.PrincipalName = $obj.principalName
      $this.MailAddress = $obj.mailAddress
      $this.Origin = $obj.origin
      $this.OriginID = $obj.originId
      $this.DisplayName = $obj.displayName

      if ($this.Origin -eq "aad")
      {
         $this.MetaType = $obj.metaType
      }

      $this.Links = @{
         'Self' = $obj._links.self.href;
         'Memberships' = $obj._links.memberships.href;
         'MembershipState' = $obj._links.membershipState.href;
         'StorageKey' = $obj._links.storageKey.href;
         'Avatar' = $obj._links.avatar.href;
      }

      $this.URL = $obj.url
      $this.Descriptor = $obj.descriptor

      $this._internalObj = $obj

      $this.AddTypeName('Team.User2')
   }

   [string]ToString() {
      return $this.PrincipalName
   }
}