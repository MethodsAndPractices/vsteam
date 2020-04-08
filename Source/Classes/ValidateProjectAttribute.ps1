using namespace System.Management.Automation

class ValidateProjectAttribute :  ValidateArgumentsAttribute {
   [void] Validate(
      [object] $arguments,
      [EngineIntrinsics]$EngineIntrinsics) {
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
