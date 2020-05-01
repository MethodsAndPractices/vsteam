using namespace System.Management.Automation

class ProcessValidateAttribute : ValidateArgumentsAttribute {
   [void] Validate(
      [object] $arguments,
      [EngineIntrinsics] $EngineIntrinsics) {
      
      if (_hasProcessTemplateCacheExpired) { 
         [VSTeamProcessCache]::processes = _getProcesses
         [VSTeamProcessCache]::timestamp = (Get-Date).Minute
      }

      if (($null -ne [VSTeamProcessCache]::processes) -and (-not ($arguments -in [VSTeamProcessCache]::processes))) {
         throw [ValidationMetadataException]::new(
            "'$arguments' is not a valid process. Valid processes are: '" +
            ([VSTeamProcessCache]::processes -join "', '") + "'")
      }
   }
}