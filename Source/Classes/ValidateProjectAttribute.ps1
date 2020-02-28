class ValidateProjectAttribute :  System.Management.Automation.ValidateArgumentsAttribute {
    [void] Validate([object] $arguments , [System.Management.Automation.EngineIntrinsics]$EngineIntrinsics) {
        if ([VSTeamProjectCache]::timestamp -lt 0 -or 
            [VSTeamProjectCache]::timestamp -lt [datetime]::Now.TimeOfDay.TotalMinutes -5) {
            [VSTeamProjectCache]::projects  =  _getProjects
            [VSTeamProjectCache]::timestamp = (get-date).TimeOfDay.TotalMinutes
        }
        if (-not ($Env:Testing -or $arguments -in [VSTeamProjectCache]::projects)) {
            throw [System.Management.Automation.ValidationMetadataException]::new(
                    "'$arguments' is not a valid project. Valid projects are: '" + 
                    ([VSTeamProjectCache]::projects -join "', '") + "'"  )
        }
        return
    }
}
