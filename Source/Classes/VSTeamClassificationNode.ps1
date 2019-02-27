class VSTeamClassificationNode : VSTeamLeaf {
    [guid]$Identifier
    [string]$StructureType = $null
    [bool]$HasChildren = $false
    [VSTeamClassificationNode[]]$Children = @()
    [string]$Path = $null
    [string]$Url = $null
    [string]$ParentUrl = $null

   VSTeamClassificationNode (
      [object]$obj,
      [string]$Projectname
   ) : base($obj.name, $obj.id, $Projectname) {
      $this.Identifier = $obj.identifier
      $this.Name = $obj.name
      $this.StructureType = $obj.structureType
      $this.HasChildren = $obj.hasChildren
      $this.Path = $obj.Path
      $this.Url = $obj.Url
      $this.Id = $obj.id

      if ($this.HasChildren)
      {
         foreach ($child in $obj.children)
         {
            $childObject = [VSTeamClassificationNode]::new($child, $ProjectName)
            $this.Children += $childObject
         }
      }

      if ([bool]($obj.PSobject.Properties.name -match "_links") -and [bool]($obj._links.PSobject.Properties.name -match "parent"))
      {
         $this.ParentUrl = $obj._links.parent.href
      }

      $this._internalObj = $obj

      $this.AddTypeName('Team.ClassificationNode')
   }
}