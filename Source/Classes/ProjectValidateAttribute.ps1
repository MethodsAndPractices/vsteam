using namespace System.Management.Automation

class ProjectValidateAttribute : ValidateArgumentsAttribute {
   [void] Validate(
      [object] $arguments,
      [EngineIntrinsics] $EngineIntrinsics) {

      #Do not fail on null or empty, leave that to other validation conditions
      if ([string]::IsNullOrEmpty($arguments)) {return}

      if (_hasProjectCacheExpired) {
         [VSTeamProjectCache]::projects = _getProjects
         [VSTeamProjectCache]::timestamp = (Get-Date).Minute
      }

      if (($null -ne [VSTeamProjectCache]::projects) -and (-not ($arguments -in [VSTeamProjectCache]::projects))) {
         throw [ValidationMetadataException]::new(
            "'$arguments' is not a valid project. Valid projects are: '" +
            ([VSTeamProjectCache]::projects -join "', '") + "'")
      }
   }
}