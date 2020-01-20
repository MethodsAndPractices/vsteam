class ProcessCompleter : System.Management.Automation.IArgumentCompleter {
  [System.Collections.Generic.IEnumerable[System.Management.Automation.CompletionResult]] CompleteArgument(
        [string]$CommandName, [string]$ParameterName, [string]$WordToComplete,
        [System.Management.Automation.Language.CommandAst]$CommandAst, [System.Collections.IDictionary] $FakeBoundParameters
  )    {
        [VSTeamProcessCache]::processes  =  _getProcesses
        [VSTeamProcessCache]::timestamp = (get-date).TimeOfDay.TotalMinutes
        $results = [System.Collections.Generic.List[System.Management.Automation.CompletionResult]]::new()
        foreach ($p in [VSTeamProcessCache]::processes ) {
            if ($p -like "*$WordToComplete*") {
                $results.Add([System.Management.Automation.CompletionResult]::new($p))
            }
        }
        return $results
  }
}
