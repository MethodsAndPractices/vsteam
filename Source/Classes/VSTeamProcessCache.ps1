# Cache process names and URLs to reduce the number of
# rest APIs calls needed for parameter completion / validation 

# Unit tests should populate cache with expected processes ideally with 
# a mock for  Get-VSTeamProcess which returns objects with name and (optionally) URL properties 
# we let them mock the testing freshness but really they should call invalidate 
class VSTeamProcessCache {
   static [int] $timestamp = -1
   static [object[]] $processes = @()
   static [hashtable] $urls = @{}

   static [Void] Update([object[]] $list) {     
      # If a list is passed in just use that
      # If not call Get-VSTeamProcess
      if (-not $list) {
         $list = Get-VSTeamProcess
      }

      if ($list) {
         foreach ($process in $list) {
            if ($process.psobject.Properties['url']) {
               [VSTeamProcessCache]::urls[$process.name] = $process.url
            }
         }
         [VSTeamProcessCache]::processes = @() + ($List | Select-Object -ExpandProperty Name | Sort-Object)
      }
      else {
         [VSTeamProcessCache]::processes = @()
      }

      [VSTeamProcessCache]::timestamp = (Get-Date).TimeOfDay.TotalMinutes
   }
   
   static [object] GetCurrent() {
      if (_hasProcessTemplateCacheExpired) { 
         [VSTeamProcessCache]::Update($null) 
      }

      return ([VSTeamProcessCache]::processes)
   }
   
   static [object] GetURl([string] $ProcessName) {
      if (_hasProcessTemplateCacheExpired) {
         [VSTeamProcessCache]::Update($null)
      }
          
      return ([VSTeamProcessCache]::urls[$ProcessName])
   }
   
   static [void] Invalidate() {
      [VSTeamProcessCache]::timestamp = -1 
   }
}