using namespace System.Collections
using namespace System.Collections.Generic
using namespace System.Management.Automation

class IconCompleter : IArgumentCompleter {
   [IEnumerable[CompletionResult]] CompleteArgument(
      [string] $CommandName,
      [string] $ParameterName,
      [string] $WordToComplete,
      [Language.CommandAst] $CommandAst,
      [IDictionary] $FakeBoundParameters) {

      $results = [List[CompletionResult]]::new()

      foreach ($w in [IconCache]::GetCurrent().where({ $_ -like "*$WordToComplete*" })) {
         $results.Add([CompletionResult]::new($w))
      }

      return $results
   }
}