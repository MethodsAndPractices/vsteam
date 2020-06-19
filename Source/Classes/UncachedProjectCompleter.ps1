using namespace System.Collections
using namespace System.Collections.Generic
using namespace System.Management.Automation

class UncachedProjectCompleter : IArgumentCompleter {
   [IEnumerable[CompletionResult]] CompleteArgument(
      [string] $CommandName, 
      [string] $ParameterName, 
      [string] $WordToComplete,
      [Language.CommandAst] $CommandAst, 
      [IDictionary] $FakeBoundParameters) {

      $results = [List[CompletionResult]]::new()
      
      [VSTeamProjectCache]::projects = _getProjects
      [VSTeamProjectCache]::timestamp = (Get-Date).Minute
      
      foreach ($value in [VSTeamProjectCache]::projects) {
         if ($value -like "*$WordToComplete*") {
            $results.Add([CompletionResult]::new("'$($value.replace("'","''"))'", $value, 0, $value))
         }
      } 
      
      return $results
   }
}
