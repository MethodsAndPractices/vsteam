using namespace System.Collections
using namespace System.Collections.Generic
using namespace System.Management.Automation

# This class defines an attribute that allows the user the tab complete
# process templates for function parameters.
class ProcessTemplateCompleter : IArgumentCompleter {
   [IEnumerable[CompletionResult]] CompleteArgument(
      [string] $CommandName,
      [string] $ParameterName,
      [string] $WordToComplete,
      [Language.CommandAst] $CommandAst,
      [IDictionary] $FakeBoundParameters) {

      $results = [List[CompletionResult]]::new()

      foreach ($value in ([VSTeamProcessCache]::GetCurrent() | Where-Object {$_ -like "*$WordToComplete*"})) {
         if ($value -match "\W") {
               $results.Add([CompletionResult]::new("'$($value.replace("'","''"))'", $value, 0, $value))
         }
         else {$results.Add([CompletionResult]::new($value)) }
      }

      return $results
   }
}
