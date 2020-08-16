class VSTeamExtension : VSTeamLeaf {
   [string]$publisherId
   [string]$extensionId
   [string]$publisherName
   [string]$version
   [vsteam_lib.InstallState]$installState

   VSTeamExtension (
      [object]$obj
   ) : base($obj.extensionName, $obj.extensionId, $null) {

      $this.extensionId = $obj.extensionId
      $this.publisherId = $obj.publisherId
      $this.publisherName = $obj.publisherName
      $this.version = $obj.version
      $this.installState = [vsteam_lib.InstallState]::new($obj.installState)

      $this._internalObj = $obj

      $this.AddTypeName('Team.Extension')
   }
}