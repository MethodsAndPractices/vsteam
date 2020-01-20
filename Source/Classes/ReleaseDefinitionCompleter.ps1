class ReleaseDefinitionCompleter : System.Management.Automation.IArgumentCompleter {
  [System.Collections.Generic.IEnumerable[System.Management.Automation.CompletionResult]] CompleteArgument(
        [string]$CommandName, [string]$ParameterName, [string]$WordToComplete,
        [System.Management.Automation.Language.CommandAst]$CommandAst, [System.Collections.IDictionary] $FakeBoundParameters
  )    {
        $results = [System.Collections.Generic.List[System.Management.Automation.CompletionResult]]::new()
        if ($Global:PSDefaultParameterValues["*:projectName"]){
            foreach ($r in (Get-VSTeamReleaseDefinition -ProjectName $Global:PSDefaultParameterValues["*:projectName"]).name ) {
                if  ($r -like "*$WordToComplete*") {
                        $results.Add([System.Management.Automation.CompletionResult]::new($r))
                }
            }
        }
        return $results
  }
}
