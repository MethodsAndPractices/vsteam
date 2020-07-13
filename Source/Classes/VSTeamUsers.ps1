using namespace Microsoft.PowerShell.SHiPS

[SHiPSProvider(UseCache = $true)]
[SHiPSProvider(BuiltinProgress = $false)]
class VSTeamUsers : VSTeamDirectory {

   # Default constructor
   VSTeamUsers(
      [string]$Name
   ) : base($Name, $null) {
      $this.AddTypeName('Team.Users')

      $this.DisplayMode = 'd-r-s-'
   }

   [object[]] GetChildItem() {
      $Users = Get-VSTeamUser | Sort-Object name

      $objs = @()

      foreach ($User in $Users) {
         $User.AddTypeName('Team.Provider.User')

         $objs += $User
      }

      return $objs
   }
}