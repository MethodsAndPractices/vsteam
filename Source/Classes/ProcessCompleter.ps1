class ProcessCompleter : System.Management.Automation.IArgumentCompleter {
  [System.Collections.Generic.IEnumerable[System.Management.Automation.CompletionResult]] CompleteArgument(
        [string]$CommandName, [string]$ParameterName, [string]$WordToComplete,
        [System.Management.Automation.Language.CommandAst]$CommandAst, [System.Collections.IDictionary] $FakeBoundParameters
  )    {
        $minutesNow = (Get-Date).TimeOfDay.TotalMinutes
        if ( (([VSTeamProcessCache]::processes -notcontains $arguments) -or 
              ([VSTeamProcessCache]::timestamp + 100 -lt $minutesNow) ) -and ( [VSTeamVersions]::Account) ) { 
               [VSTeamProcessCache]::processes = (Invoke-VSTeamRequest -url  ('{0}/_apis/process/processes?api-version={1}&stateFilter=All&$top=9999' -f [VSTeamVersions]::Account, [VSTeamVersions]::Core  )).value.name
               [VSTeamProcessCache]::timestamp = $minutesNow
        }
        $results = [System.Collections.Generic.List[System.Management.Automation.CompletionResult]]::new()
        foreach ($p in [VSTeamProcessCache]::processes ) {
            if ($p -like "*$WordToComplete*") {
                $results.Add([System.Management.Automation.CompletionResult]::new($p))
            }
        }
        return $results
  }
}
