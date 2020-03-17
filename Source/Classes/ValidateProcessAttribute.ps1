class ValidateProcessAttribute :  System.Management.Automation.ValidateArgumentsAttribute {
  [void] Validate([object] $arguments , [System.Management.Automation.EngineIntrinsics]$EngineIntrinsics) {
        $minutesNow = (Get-Date).TimeOfDay.TotalMinutes
        if ( (([VSTeamProcessCache]::processes -notcontains $arguments) -or 
              ([VSTeamProcessCache]::timestamp + 100 -lt $minutesNow) ) -and ( [VSTeamVersions]::Account) ) { 
               [VSTeamProcessCache]::processes = (Invoke-VSTeamRequest -url  ('{0}/_apis/process/processes?api-version={1}&stateFilter=All&$top=9999' -f [VSTeamVersions]::Account, [VSTeamVersions]::Core  )).value.name
               [VSTeamProcessCache]::timestamp = $minutesNow
        }
        if (-not ($env:Testing -or $arguments -in [VSTeamProcessCache]::processes)) {
            throw [System.Management.Automation.ValidationMetadataException]::new(
                "'$arguments' is not a valid process. Valid processes are: '" +
                ([VSTeamProcessCache]::processes -join "', '") + "'"  )
        }
        return
  }
}