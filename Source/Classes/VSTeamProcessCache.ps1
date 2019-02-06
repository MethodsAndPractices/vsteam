# Dynamic parameters get called alot. This can cause
# multiple calls to TFS/VSTS for a single function call
# so I am going to try and cache the values.
class VSTeamProcessCache {
   static [int] $timestamp = -1
   static [object] $processes = $null
}