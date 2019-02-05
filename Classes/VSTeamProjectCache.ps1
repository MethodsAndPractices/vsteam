# Dynamic parameters get called alot. This can cause
# multiple calls to TFS/VSTS for a single function call
# so I am going to try and cache the values.
class VSTeamProjectCache {
   static [int] $timestamp = -1
   static [object] $projects = $null
}