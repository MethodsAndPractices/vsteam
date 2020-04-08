using namespace System.Collections
using namespace System.Collections.Generic
using namespace System.Management.Automation

class TeamQueueCompleter : IArgumentCompleter {
   [IEnumerable[CompletionResult]] CompleteArgument(
      [string] $CommandName,
      [string] $ParameterName,
      [string] $WordToComplete,
      [Language.CommandAst] $CommandAst,
      [IDictionary] $FakeBoundParameters
   ) {
      $results = [List[CompletionResult]]::new()
      
      $projName = $FakeBoundParameters['ProjectName'] 
      
      if (-not $projName -and $Global:PSDefaultParameterValues["*:projectName"]) {
         $projName = $Global:PSDefaultParameterValues["*:projectName"]
      }
      
      if ($projName) { 
         foreach ($q in (Get-VSTeamQueue -ProjectName $projName).name ) {
            if ($q -like "*$WordToComplete*") {
               $results.Add([CompletionResult]::new($q))
            }
         }
      }
      
      return $results
   }
}
