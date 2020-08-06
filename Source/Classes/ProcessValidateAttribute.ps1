using namespace System.Management.Automation

class ProcessValidateAttribute : ValidateArgumentsAttribute {
   [void] Validate(
      [object] $arguments,
      [EngineIntrinsics] $EngineIntrinsics) {

      # Do not fail on null or empty, leave that to other validation conditions
      if ([string]::IsNullOrEmpty($arguments)) {
         return 
      }

      $cachedProcesses = [vsteam_lib.ProcessTemplateCache]::GetCurrent()

      if (($cachedProcesses.count -gt 0) -and ($arguments -notin $cachedProcesses)) {
         throw [ValidationMetadataException]::new(
            "'$arguments' is not a valid process. Valid processes are: '" +
            ($cachedProcesses -join "', '") + "'")
      }
   }
}