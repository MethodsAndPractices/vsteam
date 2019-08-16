class VSTeamReleaseDefinition : VSTeamLeaf {

   [string]$Url = ''
   [string]$Path = ''
   [int]$Revision = 0
   [object]$Tags = $null
   [string]$Description = ''
   [bool]$isDeleted = $false
   [object]$Triggers = $null
   [object]$Artifacts = $null
   [object]$Variables = $null
   [object]$Properties = $null
   [object]$Environments = $null
   [object]$VariableGroups = $null
   [string]$ReleaseNameFormat = ''
   [VSTeamUserEntitlement]$CreatedBy = $null
   [VSTeamUserEntitlement]$ModifiedBy = $null
   [datetime]$CreatedOn = [datetime]::MinValue
   [datetime]$ModifiedOn = [datetime]::MinValue

   # Before this class was added to the provider there
   # was a type file to expose createdByUser. The type
   # was deleted when this class was added. So this 
   # property is for backwards compatiablity 
   [string]$createdByUser = ''
   
   VSTeamReleaseDefinition(
      [object]$obj,
      [string]$Projectname
   ) : base($obj.name, $obj.id.ToString(), $Projectname) {

      $this._internalObj = $obj

      $this.Url = $obj.url
      $this.Path = $obj.path
      $this.Revision = $obj.revision
      $this.CreatedOn = $obj.createdOn
      $this.isDeleted = $obj.isDeleted
      $this.ModifiedOn = $obj.modifiedOn
      $this.Properties = $obj.Properties
      $this.Description = $obj.Description
      $this.VariableGroups = $obj.VariableGroups
      $this.ReleaseNameFormat = $obj.releaseNameFormat
      $this.CreatedBy = [VSTeamUserEntitlement]::new($obj.createdBy, $null)
      $this.ModifiedBy = [VSTeamUserEntitlement]::new($obj.modifiedBy, $null)

      $this.createdByUser = $this.CreatedBy.DisplayName

      # These properties are not always on the object returned.
      $this.SetProp($obj, 'tags')
      $this.SetProp($obj, 'variables')
      $this.SetProp($obj, 'triggers')
      $this.SetProp($obj, 'artifacts')
      $this.SetProp($obj, 'environments')

      $this.AddTypeName('Team.ReleaseDefinition')

      $this._internalObj._links.PSObject.TypeNames.Insert(0, 'Team.Links')
      $this._internalObj._links.self.PSObject.TypeNames.Insert(0, 'Team.Link')
      $this._internalObj._links.web.PSObject.TypeNames.Insert(0, 'Team.Link')
      $this._internalObj.createdBy.PSObject.TypeNames.Insert(0, 'Team.User')
      $this._internalObj.modifiedBy.PSObject.TypeNames.Insert(0, 'Team.User')

      # This is not always returned depends on expand flag
      if ($this._internalObj.PSObject.Properties.Match('artifacts').count -gt 0 -and $null -ne $this._internalObj.artifacts) {
         $this._internalObj.artifacts.PSObject.TypeNames.Insert(0, 'Team.Artifacts')
      }

      if ($this._internalObj.PSObject.Properties.Match('retentionPolicy').count -gt 0 -and $null -ne $this._internalObj.retentionPolicy) {
         $this._internalObj.retentionPolicy.PSObject.TypeNames.Insert(0, 'Team.RetentionPolicy')
      }

      if ($this._internalObj.PSObject.Properties.Match('lastRelease').count -gt 0 -and $null -ne $this._internalObj.lastRelease) {
         # This is VSTS
         $this._internalObj.lastRelease.PSObject.TypeNames.Insert(0, 'Team.Release')
      }
   }
}