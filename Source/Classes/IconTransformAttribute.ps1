using namespace System.Management.Automation

class IconTransformAttribute : ArgumentTransformationAttribute {
   [object] Transform(
      [EngineIntrinsics] $EngineIntrinsics,
      [object] $InputData
   ) {
      # if icon is a word which doesn't have ICON_ before it - add icon_ But it must be cached
      if ($InputData -and $InputData -notmatch "^icon_\w+") {
         $InputData = "icon_$InputData" 
      }
         
      if ($InputData -and $InputData -notin [IconCache]::GetCurrent()) {
         throw [ValidationMetadataException]::new("'$InputData' is not a valid icon name.") 
      }

      return $InputData
   }
}
