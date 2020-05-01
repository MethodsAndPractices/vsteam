using namespace System.Management.Automation

class WorkItemTypeValidateAttribute : ValidateArgumentsAttribute {
   [void] Validate(
      [object] $arguments,
      [EngineIntrinsics] $EngineIntrinsics) {
      
      if (_getDefaultProject) {
         $types = _getWorkItemTypes -ProjectName $(_getDefaultProject)

         if (($null -ne $types) -and (-not ($arguments -in $types))) {
            throw [ValidationMetadataException]::new(
               "'$arguments' is not a valid WorkItemType. Valid WorkItemTypees are: '" +
               ($types -join "', '") + "'")
         }
      }
   }
}