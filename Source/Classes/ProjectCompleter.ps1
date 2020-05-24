using namespace System.Collections
using namespace System.Collections.Generic
using namespace System.Management.Automation
# This class defines an attribute that allows the user the tab complete project names
# for function parameters. 
class ProjectCompleter : IArgumentCompleter {
   [IEnumerable[CompletionResult]] CompleteArgument(
      [string] $CommandName,
      [string] $ParameterName,
      [string] $WordToComplete,
      [Language.CommandAst] $CommandAst,
      [IDictionary] $FakeBoundParameters) {

      $results = [List[CompletionResult]]::new()

      $wildCard  =  $WordToComplete -replace "^'?(.*)'$",'*$1*' 
      foreach ($value in [VSTeamProjectCache]::GetCurrent().where({$_ -like $wildCard}) ) {
         if ($value -match "\W") {
               $results.Add([CompletionResult]::new("'$($value.replace("'","''"))'", $value, 0, $value))
         }
         else {$results.Add([CompletionResult]::new($value)) }
      }
      return $results
   }
}