using namespace System.Collections
using namespace System.Collections.Generic
using namespace System.Management.Automation

class ProcessCompleter : IArgumentCompleter {
   [IEnumerable[CompletionResult]] CompleteArgument(
      [string] $CommandName,
      [string] $ParameterName,
      [string] $WordToComplete,
      [Language.CommandAst] $CommandAst,
      [IDictionary] $FakeBoundParameters) {
      
      $minutesNow = (Get-Date).TimeOfDay.TotalMinutes
      
      if (([VSTeamProcessCache]::timestamp + 100 -lt $minutesNow) -and ([VSTeamVersions]::Account)) {
         [VSTeamProcessCache]::processes = (Invoke-VSTeamRequest -url  ('{0}/_apis/process/processes?api-version={1}&stateFilter=All&$top=9999' -f [VSTeamVersions]::Account, [VSTeamVersions]::Core  )).value.name
         [VSTeamProcessCache]::timestamp = $minutesNow
      }
      
      $results = [List[CompletionResult]]::new()

      foreach ($p in [VSTeamProcessCache]::processes) {
         if ($p -like "*$WordToComplete*") {
            $results.Add([CompletionResult]::new($p))
         }
      }
      
      return $results
   }
}
