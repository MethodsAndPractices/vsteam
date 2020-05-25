# cache process names and URLs to reduce the number of
# rest APIs calls needed for parameter completion / validation 

#Unit tests should populate cache with expected processes ideally with 
# a mock for  Get-VSTeamProcess which returns objects with name and (optionally) URL properties 
# we let them mock the testing freshness but really they should call invalidate 
class VSTeamProcessCache {
   static [int] $timestamp = -1
   static [object[]] $processes = @()
   static [hashtable] $urls = @{}
   static [Void] Update () {     
      [VSTeamProcessCache]::processes = @()
      #Get-VSTeamProcess should call update(listOfProcesses), 
      #but it if doesn't (e.g. a simple mock) processes will still be empty, and we can call it
      $list = Get-VSTeamProcess
      if ([VSTeamProcessCache]::processes.Count -eq 0) {[VSTeamProcessCache]::Update($list) }
   }
   static [Void] Update ([object[]]$NewItems) {
      [VSTeamProcessCache]::processes = $NewItems | Select-Object -ExpandProperty Name | Sort-Object
      $NewItems | Where-Object {$_.psobject.Properties['url']} | ForEach-Object {
            [VSTeamProcessCache]::urls[$_.name] = $_.url
      }
      [VSTeamProcessCache]::timestamp = (Get-Date).Minute
   }
   #"save current minute" refreshes on average after 30secs  but not after exact hours timeOfDayTotalMinutes might be a better base
   static [bool] HasExpired () {
      return $([VSTeamProcessCache]::timestamp) -ne (Get-Date).Minute
   }
   static [object] GetCurrent () {
      if ([VSTeamProcessCache]::HasExpired()) { [VSTeamProcessCache]::Update() }
      return ([VSTeamProcessCache]::processes)
   }
   static [object] GetURl ([string]$ProcessName) {
      if ([VSTeamProcessCache]::HasExpired()) { [VSTeamProcessCache]::Update() }
      return ([VSTeamProcessCache]::urls[$ProcessName])
   }
   static [void] Invalidate () {
      [VSTeamProcessCache]::timestamp = -1 
   }
}