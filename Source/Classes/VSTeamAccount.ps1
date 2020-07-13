using namespace Microsoft.PowerShell.SHiPS

[SHiPSProvider(UseCache = $true)]
[SHiPSProvider(BuiltinProgress = $false)]
class VSTeamAccount : SHiPSDirectory {

   # Default constructor
   VSTeamAccount(
      [string]$Name
   ) : base($Name) {
      $this.AddTypeName('Team.Account')

      # Invalidate any cache of projects.
      [VSTeamProjectCache]::Invalidate()
   }

   [object[]] GetChildItem() {
      $topLevelFolders = @(
         [VSTeamPools]::new('Agent Pools'),
         [VSTeamExtensions]::new('Extensions')
         [VSTeamFeeds]::new('Feeds')
      )
      
      # Don't show directories not supported by the server
      if (_testGraphSupport) {
         $topLevelFolders += [VSTeamPermissions]::new('Permissions')
      }

      $items = Get-VSTeamProject | Sort-Object Name

      foreach ($item in $items) {
         $item.AddTypeName('Team.Provider.Project')
         $topLevelFolders += $item
      }

      return $topLevelFolders
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