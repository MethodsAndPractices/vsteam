using namespace System.Management.Automation

class UncachedProjectValidateAttribute :  ValidateArgumentsAttribute {
   [void] Validate(
      [object] $arguments,
      [EngineIntrinsics] $EngineIntrinsics) {
      
      $cachedProjects = [VSTeamProjectCache]::GetCurrent($true)
        
      if (-not  $arguments -in $cachedProjects) {
         throw [ValidationMetadataException]::new(
            "'$arguments' is not a valid project. Valid projects are: '" +
            ($cachedProjects -join "', '") + "'"  )
      }
   }
}