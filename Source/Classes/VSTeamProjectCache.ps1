# Dynamic parameters get called alot. This can cause
# multiple calls to TFS/VSTS for a single function call
# so I am going to try and cache the values.
class VSTeamProjectCache {
   static [int] $timestamp = -1
   static [object] $projects = $null

   static [Void] Update() {
      # Allow unit tests to mock returning the project list and testing freshness
      [VSTeamProjectCache]::projects = _getProjects
      
      [VSTeamProjectCache]::timestamp = (Get-Date).TimeOfDay.TotalMinutes
   }

   static [void] Invalidate() {
      [VSTeamProjectCache]::timestamp = -1
   }

   static [object] GetCurrent([bool] $forceUpdate) {
      if (_hasProjectCacheExpired -or $forceUpdate) { 
         [VSTeamProjectCache]::Update() 
      }

      return ([VSTeamProjectCache]::projects)
   }
}