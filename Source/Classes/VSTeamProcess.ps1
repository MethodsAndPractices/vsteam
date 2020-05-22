class VSTeamProcess {

   [string]$ID = $null
   [string]$URL = $null
   [string]$Description = $null
   [string]$Name = $null
   [string]$ReferenceName = $null
   [bool]$IsEnabled = $true
   [bool]$IsDefault = $false
   [string]$Type = $null
   [string]$ProcessTemplate = $null
   [string]$ParentProcessTypeId = $null
   VSTeamProcess (
      [object]$obj
   )  {
      $this.AddTypeName('Team.Process')
      $this.Name                    = $obj.name
      $this.ProcessTemplate         = $obj.name
      #Allow for processes from .../process/processes with ID property, or ...work/processes with TypeID
      if ($obj.PSObject.Properties['typeId']) {
         $this.ID                      = $obj.typeId
         $this.URL                     = (_getInstance) + "/_apis/work/processes/" + $obj.typeId
      }
      elseIf ($obj.PSObject.Properties['Id']) {
         $this.ID                      = $obj.Id
         $this.URL                     = (_getInstance) + "/_apis/work/processes/" + $obj.ID
      }
      if ($obj.PSObject.Properties['isEnabled']) {
         $this.IsEnabled            = $obj.isEnabled
      }
      if ($obj.PSObject.Properties['isDefault']) {
         $this.IsDefault            = $obj.isDefault
      }
      if ($obj.PSObject.Properties['referenceName']) {
         $this.ReferenceName        = $obj.referenceName
      }
      if ($obj.PSObject.Properties['customizationType']) {
         $this.Type                 = $obj.customizationType
      }
      # The description is not always returned so protect yourself.
      if ($obj.PSObject.Properties['description']) {
         $this.Description          = $obj.description
      }
      if ($obj.PSObject.Properties['parentProcessTypeId']) {
         $this.ParentProcessTypeId  = $obj.parentProcessTypeId
      }
   }

   [void] hidden AddTypeName(
      [string] $name
   ) {
      # The type is used to identify the correct formatter to use.
      # The format for when it is returned by the function and
      # returned by the provider are different. Adding a type name
      # identifies how to format the type.
      # When returned by calling the function and not the provider.
      # This will be formatted without a mode column.
      # When returned by calling the provider.
      # This will be formatted with a mode column like a file or
      # directory.
      $this.PSObject.TypeNames.Insert(0, $name)
   }

   [string]ToString() {
      return $this.Name
   }
}