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
      
      # Force an update of the cache
      $cachedProjects = [VSTeamProjectCache]::GetCurrent($true)
      
      foreach ($value in $cachedProjects) {
         if ($value -like "*$WordToComplete*") {
            $results.Add([CompletionResult]::new("'$($value.replace("'","''"))'", $value, 0, $value))
         }
      } 
      
      return $results
   }
}
