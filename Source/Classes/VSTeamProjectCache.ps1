# Dynamic parameters get called alot. This can cause
# multiple calls to TFS/VSTS for a single function call
# so I am going to try and cache the values.
class VSTeamProjectCache {
   static [int] $timestamp = -1
   static [object[]] $projects = @()
   #Allow the class to be  updated with a list. If no list is given we'll get the one first 
   static [Void] Update ([object[]]$NewItems) {
      [VSTeamProjectCache]::projects = $NewItems 
      [VSTeamProjectCache]::timestamp =  (Get-Date).Minute
      # "save current minute" refreshes on average after 30secs  but not after exact hours timeOfDayTotalMinutes might be a better base
   }
   static [Void] Update () {
      #unit tests use _getProjects to mock returning the project list and testing freshness make self contained later but means changing multiple tests
      [VSTeamProjectCache]::projects = @() 
      $list = _getProjects
      #if getting the list doesn't auto update the cache...
      if ([VSTeamProjectCache]::projects.Count -eq 0) {[VSTeamProjectCache]::Update( $list )}
   }

   static [bool] HasExpired () { return (_hasProjectCacheExpired) }
   static [object] GetCurrent () {
      if ([VSTeamProjectCache]::HasExpired()) { [VSTeamProjectCache]::Update() }
      return ([VSTeamProjectCache]::projects)
   }
   static [void] Invalidate () {
      [VSTeamProjectCache]::timestamp = -1
   }
}