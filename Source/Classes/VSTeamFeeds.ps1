using namespace Microsoft.PowerShell.SHiPS

[SHiPSProvider(UseCache = $true)]
[SHiPSProvider(BuiltinProgress = $false)]
class VSTeamFeeds : VSTeamDirectory {

   # Default constructor
   VSTeamFeeds(
      [string]$Name
   ) : base($Name, $null) {
      $this.AddTypeName('Team.Feeds')

      $this.DisplayMode = 'd-r-s-'
   }

   [object[]] GetChildItem() {
      $feeds = Get-VSTeamFeed | Sort-Object name

      $objs = @()

      foreach ($feed in $feeds) {
         $feed.AddTypeName('Team.Provider.Feed')

         $objs += $feed
      }

      return $objs
   }
}