using namespace System.Collections
using namespace System.Collections.Generic
using namespace System.Management.Automation

class AreaCompleter : IArgumentCompleter {
   [IEnumerable[CompletionResult]] CompleteArgument(
      [string] $CommandName,
      [string] $ParameterName,
      [string] $WordToComplete,
      [Language.CommandAst] $CommandAst,
      [IDictionary] $FakeBoundParameters) {

      $results = [List[CompletionResult]]::new()

      @("build", "Contribution", "distributedtask", "git", "graph", "packaging", "policy", "process", "release", "tfvc", "wit"
       ).where({$_ -like "$wordToComplete*"}) | ForEach-Object {
            $results.Add([CompletionResult]::new($_))
      }
      return $results
   }
}
