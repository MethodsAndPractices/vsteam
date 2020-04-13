using namespace System.Collections
using namespace System.Collections.Generic
using namespace System.Management.Automation

class BuildDefinitionCompleter : IArgumentCompleter {
   [IEnumerable[CompletionResult]] CompleteArgument(
      [string] $CommandName,
      [string] $ParameterName,
      [string] $WordToComplete,
      [Language.CommandAst] $CommandAst,
      [IDictionary] $FakeBoundParameters) {

      $results = [List[CompletionResult]]::new()

      if (_getDefaultProject) {
         foreach ($b in (Get-VSTeamBuildDefinition -ProjectName $(_getDefaultProject))) {
            if ($b.name -like "*$WordToComplete*") {
               $results.Add([CompletionResult]::new($b.name))
            }
         }
      }

      return $results
   }
}
