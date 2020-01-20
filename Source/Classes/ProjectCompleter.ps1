class ProjectCompleter : System.Management.Automation.IArgumentCompleter {
    [System.Collections.Generic.IEnumerable[System.Management.Automation.CompletionResult]] CompleteArgument(
        [string]$CommandName, [string]$ParameterName, [string]$WordToComplete,
        [System.Management.Automation.Language.CommandAst]$CommandAst, [System.Collections.IDictionary] $FakeBoundParameters
    )    {
        if ([VSTeamProjectCache]::timestamp -lt 0 -or 
            [VSTeamProjectCache]::timestamp -lt [datetime]::Now.TimeOfDay.TotalMinutes - 5) {
            [VSTeamProjectCache]::projects  =  _getProjects
            [VSTeamProjectCache]::timestamp = (get-date).TimeOfDay.TotalMinutes
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
