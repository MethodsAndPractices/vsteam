using namespace System.Management.Automation

class ColorTransformToHexAttribute : ArgumentTransformationAttribute {
   [object] Transform(
      [System.Management.Automation.EngineIntrinsics]$EngineIntrinsics, 
      [object] $InputData
   ) {
      # if it is a sting but not '#123456' or '123456' try to it into a system.drawing.color
      if ($InputData -is [string] -and $InputData -notmatch '^#?[\da-f]{6}$') {
         try { $InputData = [System.Drawing.Color]::$InputData }
         catch { Throw [System.Management.Automation.ParameterBindingException]::new("'$InputData' doesn't match a system color.") }
      }

      # if it was or has now become a color, transform it into 11aabb Hex format for r,g,b values
      if ($InputData -is [System.Drawing.Color]) {
         $InputData = "{0:x2}{1:x2}{2:x2}" -f $InputData.R, $InputData.G , $InputData.B
      }
      
      # If we didn't get a string or color, or the conversion return "black"
      if ($InputData -notmatch '^#?[\da-f]{6}$') {
         Write-Warning "Could not transform color into 0a1b2c format. Will use 000000 instead "
         $InputData = '000000'
      }  
      
      # if we were give "#123456" strip the leading hash
      return ($InputData -replace '^#', '')
   }
}
