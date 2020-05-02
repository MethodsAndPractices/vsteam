# Dynamic parameters get called alot. This can cause
# multiple calls to TFS/VSTS for a single function call
# so I am going to try and cache the values.
class VSTeamProcessCache {
   static [int] $timestamp = -1
   static [object] $processes = $null
   static [Void] Update () {
      #Allow unit tests to mock returning the project list and testing freshness
      [VSTeamProcessCache]::processes = _getProcesses
      [VSTeamProcessCache]::timestamp = (Get-Date).Minute
      # "save current minute" refreshes on average after 30secs  but not after exact hours timeOfDayTotalMinutes might be a better base
   }
   static [object] GetCurrent () {
      if (_hasProcessTemplateCacheExpired) { [VSTeamProcessCache]::Update() }
      return ([VSTeamProcessCache]::processes)
   }
}