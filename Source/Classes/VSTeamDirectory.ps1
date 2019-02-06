using namespace Microsoft.PowerShell.SHiPS

class VSTeamDirectory : SHiPSDirectory {
   # The object returned from the REST API call
   [object] hidden $_internalObj = $null

   # I want the mode to resemble that of
   # a normal file system.
   # d - Directory
   # a - Archive
   # r - Read-only
   # h - Hidden
   # s - System
   # l - Reparse point, symlink, etc.
   [string] hidden $DisplayMode = 'd-----'

   [string]$ProjectName = $null

   # Default constructor
   VSTeamDirectory(
      [string]$Name,
      [string]$ProjectName
   ) : base($Name) {
      $this.ProjectName = $ProjectName
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
}