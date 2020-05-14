using namespace System.Management.Automation

class WorkItemTypeValidateAttribute : ValidateArgumentsAttribute {
   [void] Validate(
      [object] $arguments,
      [EngineIntrinsics] $EngineIntrinsics) {
      #Do not fail on null or empty, leave that to other validation conditions
      if (_getDefaultProject -and -not [string]::IsNullOrEmpty($arguments)) {
         $types = [VSTeamWorkItemTypeCache]::GetCurrent()

         if (($null -ne $types) -and (-not ($arguments -in $types))) {
            throw [ValidationMetadataException]::new(
               "'$arguments' is not a valid WorkItemType. Valid WorkItemTypees are: '" +
               ($types -join "', '") + "'")
         }
      }
   }
}