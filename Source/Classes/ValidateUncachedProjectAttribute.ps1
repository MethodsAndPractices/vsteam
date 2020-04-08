using namespace System.Management.Automation

class ValidateUncachedProjectAttribute :  ValidateArgumentsAttribute {
   [void] Validate(
      [object] $arguments,
      [EngineIntrinsics] $EngineIntrinsics) {
      [VSTeamProjectCache]::projects = _getProjects
      [VSTeamProjectCache]::timestamp = (Get-Date).Minute
        
      if (-not  $arguments -in [VSTeamProjectCache]::projects) {
         throw [ValidationMetadataException]::new(
            "'$arguments' is not a valid project. Valid projects are: '" +
            ([VSTeamProjectCache]::projects -join "', '") + "'"  )
      }
      return
   }
}