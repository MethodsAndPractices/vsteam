using namespace System.Management.Automation

class ProcessValidateAttribute : ValidateArgumentsAttribute {
   [void] Validate(
      [object] $arguments,
      [EngineIntrinsics] $EngineIntrinsics) {

      #Do not fail on null or empty, leave that to other validation conditions
      if ([string]::IsNullOrEmpty($arguments)) {return}
      #tests count HTTP calls and expect 1 from reading the cache, but for a call on each read, so only read once! # 
      $CachedProcesses = [VSTeamProcessCache]::GetCurrent()
      if (($null -ne $CachedProcesses) -and ($arguments -notin $CachedProcesses) ) {
         throw [ValidationMetadataException]::new(
            "'$arguments' is not a valid process. Valid processes are: '" +
            ($CachedProcesses -join "', '") + "'")
      }
   }
}