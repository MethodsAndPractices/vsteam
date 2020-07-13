using namespace System.Collections
using namespace System.Collections.Generic
using namespace System.Management.Automation
using namespace System.Drawing

class ColorCompleter : IArgumentCompleter {
   [IEnumerable[CompletionResult]] CompleteArgument(
      [string] $CommandName,
      [string] $ParameterName,
      [string] $WordToComplete,
      [Language.CommandAst] $CommandAst,
      [IDictionary] $FakeBoundParameters) {

      $results = [List[CompletionResult]]::new()

      [KnownColor].GetFields().where( { $_.IsStatic -and $_.name -like "$wordToComplete*" }) |
      Sort-Object -Property name | ForEach-Object {
         $results.Add([CompletionResult]::new($_.name))
      }
      
      return $results
   }
}