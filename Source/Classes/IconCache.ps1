# Unlike the other cache types this doesn't use a type used in the module and 
# icons don't go stale (except when the server is updated)
class IconCache {
   static hidden [DateTime] $timestamp = 0
   static hidden [object[]] $icons = @()
   static hidden [int] $maxAgeMins = 1440 # can't change icons. Update once per day 

   # Allow the class to be updated with a list. If no list is given we'll get the one first 
   static [Void] Update ([object[]]$list) {
      [IconCache]::icons = $list 
      [IconCache]::timestamp = Get-Date
   }

   static [Void] Update ( ) {
      $list = (_callAPI -area wit -resource workitemicons -noproject ).value.id | Sort-Object 
      [IconCache]::update($list)
   }
   
   static [bool] HasExpired () {
      return ([IconCache]::timestamp.AddMinutes([IconCache]::maxAgeMins) -lt [DateTime]::Now)
   }

   static [object] GetCurrent () {
      # Update first if the default project has changed or data is too old. 
      if ([IconCache]::HasExpired()) {
         [IconCache]::Update()
      }
      return [IconCache]::icons
   }

   static [void] Invalidate () {
      [IconCache]::timestamp = -1
   }
}