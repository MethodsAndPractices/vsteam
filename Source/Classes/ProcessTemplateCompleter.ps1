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

      if (_hasProcessTemplateCacheExpired) {
         [VSTeamProcessCache]::processes = _getProcesses
         [VSTeamProcessCache]::timestamp = (Get-Date).Minute
      }

      foreach ($p in [VSTeamProcessCache]::processes) {
         if ($p -like "*$WordToComplete*" -and $p -notmatch '\W') {
            $results.Add([CompletionResult]::new($p))
         }
         elseif ($p -like "*$WordToComplete*") {
            $results.Add([CompletionResult]::new("'$p'"))
         }
      }
      return $results
   }
}
