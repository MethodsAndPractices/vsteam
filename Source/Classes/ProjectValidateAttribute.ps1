using namespace System.Management.Automation

class ProjectValidateAttribute : ValidateArgumentsAttribute {
   [void] Validate(
      [object] $arguments,
      [EngineIntrinsics] $EngineIntrinsics) {

      # Do not fail on null or empty, leave that to other validation conditions
      if ([string]::IsNullOrEmpty($arguments)) { 
         return 
      }

      $cachedProjects = [VSTeamProjectCache]::GetCurrent($false)

      if (($cachedProjects.count -gt 0) -and ($arguments -notin $cachedProjects)) {
         throw [ValidationMetadataException]::new(
            "'$arguments' is not a valid project. Valid projects are: '" +
            ($cachedProjects -join "', '") + "'")
      }
   }
}