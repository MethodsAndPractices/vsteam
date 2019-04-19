class VSTeamProcess {

   [string]$ID = $null
   [string]$URL = $null
   [string]$Description = $null
   [string]$Name = $null
   [bool]$IsDefault = $false
   [string]$Type = $null

   VSTeamProcess (
      [object]$obj
   )  {
      $this.ID = $obj.id
      $this.URL = $obj.url
      $this.IsDefault = $obj.isDefault
      $this.Name = $obj.name
      $this.Type = $obj.type

      # The description is not always returned so protect yourself.
      if ($obj.PSObject.Properties.Match('description').count -gt 0) {
         $this.Description = $obj.description
      }

      $this.AddTypeName('Team.Process')
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