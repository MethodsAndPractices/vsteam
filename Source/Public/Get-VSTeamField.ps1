function Get-VSTeamField {
   [CmdletBinding()]
   param(
      [Parameter(ValueFromPipeline=$true,Position=0)]
      [ArgumentCompleter([vsteam_lib.FieldCompleter])]
      [vsteam_lib.FieldTransformAttribute()]
      [Alias('Name')]
      $ReferenceName
   )
   process {
      if ($ReferenceName ) {
         $resp = @()
         foreach ($r in $ReferenceName){
            if ($r.psobject.Members.Name -contains "ReferenceName") {
                  $r = $r.ReferenceName
            }
            $resp +=  _callAPI -area wit -resource fields -id $r
         }
      }
      else {$resp = (_callAPI -area wit -resource fields).value}

      foreach ($r in $resp) {
            $r.psobject.TypeNames.Insert(0,'vsteam_lib.Field')
      }

      return $resp
   }
}
