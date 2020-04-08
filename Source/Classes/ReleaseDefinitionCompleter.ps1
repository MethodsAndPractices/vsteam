using namespace System.Collections
using namespace System.Collections.Generic
using namespace System.Management.Automation

class ReleaseDefinitionCompleter : IArgumentCompleter {
   [IEnumerable[CompletionResult]] CompleteArgument(
      [string] $CommandName,
      [string] $ParameterName,
      [string] $WordToComplete,
      [Language.CommandAst] $CommandAst,
      [IDictionary] $FakeBoundParameters
   ) {
      $results = [List[CompletionResult]]::new()

      if (_getDefaultProject) {
         foreach ($r in (Get-VSTeamReleaseDefinition -ProjectName $(_getDefaultProject)).name) {
            if ($r -like "*$WordToComplete*") {
               $results.Add([CompletionResult]::new($r))
            }
         }
      }

      return $results
   }
}
