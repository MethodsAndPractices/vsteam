using namespace System.Management.Automation

class UncachedProjectValidateAttribute :  ValidateArgumentsAttribute {
   [void] Validate(
      [object] $arguments,
      [EngineIntrinsics] $EngineIntrinsics) {

      #Do not fail on null or empty, leave that to other validation conditions
      if ([string]::IsNullOrEmpty($arguments)) {return}
      #force a cache update
      [VSTeamProjectCache]::Update()

      if (-not  $arguments -in [VSTeamProjectCache]::GetCurrent()) {
         throw [ValidationMetadataException]::new(
            "'$arguments' is not a valid project. Valid projects are: '" +
            ([VSTeamProjectCache]::projects -join "', '") + "'"  )
      }
   }
}