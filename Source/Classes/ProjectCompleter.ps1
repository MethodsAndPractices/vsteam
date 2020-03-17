class ProjectCompleter : System.Management.Automation.IArgumentCompleter {
    [System.Collections.Generic.IEnumerable[System.Management.Automation.CompletionResult]] CompleteArgument(
        [string]$CommandName, [string]$ParameterName, [string]$WordToComplete,
        [System.Management.Automation.Language.CommandAst]$CommandAst, [System.Collections.IDictionary] $FakeBoundParameters
    )    {
        if (  [VSTeamVersions]::Account -and 
             ([VSTeamProjectCache]::timestamp -lt 0 -or
              [VSTeamProjectCache]::timestamp -lt [datetime]::Now.TimeOfDay.TotalMinutes - 5) ) {
              [VSTeamProjectCache]::projects  = (Invoke-VSTeamRequest -url  ('{0}/_apis/projects?api-version={1}&stateFilter=All&$top=9999' -f [VSTeamVersions]::Account, [VSTeamVersions]::Core  )).value.name
              [VSTeamProjectCache]::timestamp = (Get-Date).TimeOfDay.TotalMinutes
        }
        $results = [System.Collections.Generic.List[System.Management.Automation.CompletionResult]]::new()
        foreach ($p in [VSTeamProjectCache]::projects ) {
            if ($p -like "*$WordToComplete*" -and $p -match "\s") {
                $results.Add([System.Management.Automation.CompletionResult]::new("'$p'"))
            }
            elseif ($p -like "*$WordToComplete*"){
                    $results.Add([System.Management.Automation.CompletionResult]::new($p))
            }
        }
        return $results
    }
}