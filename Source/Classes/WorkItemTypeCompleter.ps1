using namespace System.Collections
using namespace System.Collections.Generic
using namespace System.Management.Automation

class WorkItemTypeCompleter : IArgumentCompleter {
   [IEnumerable[CompletionResult]] CompleteArgument(
      [string] $CommandName, 
      [string] $ParameterName,
      [string] $WordToComplete,
      [Language.CommandAst] $CommandAst,
      [IDictionary] $FakeBoundParameters
   ) {
      $results = [List[CompletionResult]]::new()

      if (_getDefaultProject) {
         foreach ($w in (_getWorkItemTypes -ProjectName $(_getDefaultProject))) {
            if ($w -like "*$WordToComplete*") {
               $results.Add([CompletionResult]::new($w))
            }
         }
      }
      
      return $results
   }
}