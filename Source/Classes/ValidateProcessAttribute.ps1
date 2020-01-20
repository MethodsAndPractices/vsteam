class ValidateProcessAttribute :  System.Management.Automation.ValidateArgumentsAttribute {
  [void] Validate([object] $arguments , [System.Management.Automation.EngineIntrinsics]$EngineIntrinsics) {
        [VSTeamProcessCache]::processes  =  _getProcesses
        [VSTeamProcessCache]::timestamp = (get-date).TimeOfDay.TotalMinutes
        if ($arguments -notin [VSTeamProcessCache]::processes) {
            throw [System.Management.Automation.ValidationMetadataException]::new(
                "'$arguments' is not a valid process. Valid processes are: '" + 
                ([VSTeamProcessCache]::processes -join "', '") + "'"  )
        }
        return
  }
}
