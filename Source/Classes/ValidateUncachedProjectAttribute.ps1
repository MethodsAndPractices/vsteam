class ValidateUncachedProjectAttribute :  System.Management.Automation.ValidateArgumentsAttribute {
  [void] Validate([object] $arguments , [System.Management.Automation.EngineIntrinsics]$EngineIntrinsics) {
        [VSTeamProjectCache]::projects  = (Invoke-VSTeamRequest -url  ('{0}/_apis/projects?api-version={1}&stateFilter=All&$top=9999' -f [VSTeamVersions]::Account, [VSTeamVersions]::Core  )).value.name
        [VSTeamProjectCache]::timestamp = (Get-Date).TimeOfDay.TotalMinutes
        if (-not ($env:Testing -or $arguments -in [VSTeamProjectCache]::projects)) {
            throw [System.Management.Automation.ValidationMetadataException]::new(
                "'$arguments' is not a valid project. Valid projects are: '" +
                ([VSTeamProjectCache]::projects -join "', '") + "'"  )
        }
        return
  }
}