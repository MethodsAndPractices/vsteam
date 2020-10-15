function Get-VSTeamPickList{
   [CmdletBinding()]
   param (
      [ArgumentCompleter([vsteam_lib.PicklistCompleter])]
      [Parameter(ValueFromPipeline=$true, position=0)]
      [Alias('Name','ID')]
      $PicklistID = "*"
   )
   begin   {
      $resp = @()
      #we can't use the transformer if we get an array of names so use it the body
      $transformer = New-Object -TypeName vsteam_lib.PickListTransformAttribute
   }
   process {
      foreach ($p in $PicklistID) {
         #if we got an object, use its ID. If we got a name (not a wildcard) tranform it to an ID
         if ($p.psobject.Properties['id']) {
               $p = $p.id
         }
         if ($p -notmatch "\?|\*") {
            try {
               $p =  $transformer.Transform($null,$P)
               $resp += _callAPI -NoProject -area "work" -resource 'processes/lists' -id $P
            }
            catch {
               Write-Warning "$p is not a valid picklist name."
            }
         }
        else {
            $resp += (_callAPI -NoProject -area "work" -resource 'processes/lists').value |
                        Where-Object Name -like $p
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
