function Get-VSTeamPickList{
   [CmdletBinding()]
   param (
      [ArgumentCompleter([vsteam_lib.PicklistCompleter])]
      [vsteam_lib.PickListTransformAttribute()]
      [Parameter(ValueFromPipeline=$true, position=0)]
      [Alias('Name','ID')]
      $PicklistID = "*"
   )
   begin   { $resp = @() }
   process {
      foreach ($p in $PicklistID) {
         if ($p.psobject.Properties['id']) {$p = $p.id}
         if ($p -match "[0-9A-F]{8}-([0-9A-F]{4}-){3}[0-9A-F]{12}"  ) {
            $resp += _callAPI -NoProject -area "work" -resource '/processes/lists' -id $P
         }
        else {
            $resp += (_callAPI -NoProject -area "work" -resource '/processes/lists').value | 
                        Where-Object Name -like $PicklistID
         }
      }
   }
   end {
      foreach ($r in $resp) {
         $r.psobject.TypeNames.Insert(0,'vsteam_lib.PickList')
      }

      return $resp 
   }
}
