using namespace System.Collections
using namespace System.Collections.Generic
using namespace System.Management.Automation

class BuildCompleter : IArgumentCompleter {
   [IEnumerable[CompletionResult]] CompleteArgument(
      [string] $CommandName,
      [string] $ParameterName,
      [string] $WordToComplete,
      [Language.CommandAst] $CommandAst,
      [IDictionary] $FakeBoundParameters
   ) {
      $results = [List[CompletionResult]]::new()

      if (_getDefaultProject) {
         foreach ($b in (Get-VSTeamBuild -ProjectName $(_getDefaultProject)).name) {
            if ($b -like "*$WordToComplete*") {
               $results.Add([CompletionResult]::new($b))
            }
         }
      }

      return $results
   }
}
