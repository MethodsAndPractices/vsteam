class ValidateUncachedProjectAttribute :  System.Management.Automation.ValidateArgumentsAttribute {
  [void] Validate([object] $arguments , [System.Management.Automation.EngineIntrinsics]$EngineIntrinsics) {
        [VSTeamProjectCache]::projects  =  _getProjects
        [VSTeamProjectCache]::timestamp = (get-date).TimeOfDay.TotalMinutes
        if ($arguments -notin [VSTeamProjectCache]::projects) {
            throw [System.Management.Automation.ValidationMetadataException]::new(
                "'$arguments' is not a valid project. Valid projects are: '" + 
                ([VSTeamProjectCache]::projects -join "', '") + "'"  )
        }
        return
  }
}
