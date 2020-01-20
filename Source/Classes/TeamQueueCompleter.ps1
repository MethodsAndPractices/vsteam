class TeamQueueCompleter : System.Management.Automation.IArgumentCompleter {
  [System.Collections.Generic.IEnumerable[System.Management.Automation.CompletionResult]] CompleteArgument(
        [string]$CommandName, [string]$ParameterName, [string]$WordToComplete,
        [System.Management.Automation.Language.CommandAst]$CommandAst, [System.Collections.IDictionary] $FakeBoundParameters
  )    {
        $results = [System.Collections.Generic.List[System.Management.Automation.CompletionResult]]::new()
        $projName = $FakeBoundParameters['ProjectName'] 
        if (-not $projName -and $Global:PSDefaultParameterValues["*:projectName"]) {
            $projName = $Global:PSDefaultParameterValues["*:projectName"]
        }
        if ($projName) { 
            foreach ($q in (Get-VSTeamQueue -ProjectName $projName).name ) {
                if  ($q -like "*$WordToComplete*") {
                        $results.Add([System.Management.Automation.CompletionResult]::new($q))
                }
            }
        }
        return $results
  }
}
