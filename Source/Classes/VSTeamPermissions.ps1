using namespace Microsoft.PowerShell.SHiPS

[SHiPSProvider(UseCache = $true)]
[SHiPSProvider(BuiltinProgress = $false)]
class VSTeamPermissions : VSTeamDirectory {

   # Default constructor
   VSTeamPermissions(
      [string]$Name
   ) : base($Name, $null) {
      $this.AddTypeName('Team.Permissions')

      $this.DisplayMode = 'd-r-s-'
   }

   [object[]] GetChildItem() {
      $groupsAndUsers = @(
         [VSTeamGroups]::new('Groups'),
         [VSTeamUsers]::new('Users')
      )

      return $groupsAndUsers
   }
}