#Unlike the other cache types this doesn't to a type  used in the module and icons don't go stale (except when the server is updated)
class IconCache {
   static hidden [dateTime]  $Timestamp   = 0
   static hidden [object[]]  $Icons       = @()
   static hidden [int]       $MaxAgeMins  = 1440 # can't change icons. Update once per day 

   #Allow the class to be  updated with a list. If no list is given we'll get the one first 
   static [Void] Update ([object[]]$NewItems) {
      [IconCache]::Icons = $NewItems 
      [IconCache]::timestamp = Get-Date
   }
   static [Void] Update ( ) {
      $list = (_callAPI -area wit -resource workitemicons -noproject ).value.id |  Sort-Object 
      [IconCache]::update($list)
   }
   static [bool] HasExpired () {
      return ([IconCache]::timestamp.AddMinutes([IconCache]::MaxAgeMins)  -lt [datetime]::Now)
   }

   static [object] GetCurrent () {
         #Update first if the default project has changed or data is too old. 
      if    ([IconCache]::HasExpired()) {
             [IconCache]::Update()
      }
      return [IconCache]::Icons
   }

   static [void] Invalidate () {
      [IconCache]::timestamp = 0
   }

}