class VSTeamRef : VSTeamLeaf {
   [VSTeamUserEntitlement]$Creator = $null

   # The name passed to the base class is changed. For example if you pass
   # refs/heads/appcenter as the name it is converted into refs-heads-appcenter.
   # So I store it twice so I have the original value as well.
   [string]$RefName = $null

   VSTeamRef (
      [object]$obj,
      [string]$ProjectName
   ) : base($obj.name, $obj.objectId, $ProjectName) {

      $this.RefName = $obj.name
      $this.Creator = [VSTeamUserEntitlement]::new($obj.creator, $ProjectName)

      $this._internalObj = $obj

      $this.AddTypeName('Team.GitRef')
   }
}