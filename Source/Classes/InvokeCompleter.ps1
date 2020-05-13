using namespace System.Collections
using namespace System.Collections.Generic
using namespace System.Management.Automation

# This class defines an attribute that allows the user the tab complete
# areas for Invoke-VSTeamRequest for function parameters.
class InvokeCompleter : IArgumentCompleter {
   [IEnumerable[CompletionResult]] CompleteArgument(
      [string] $CommandName,
      [string] $ParameterName,
      [string] $WordToComplete,
      [Language.CommandAst] $CommandAst,
      [IDictionary] $FakeBoundParameters) {

      $results = [List[CompletionResult]]::new()

      # If the user has explictly added the -subDomain parameter
      # to the command use that to filter the results.
      $subDomain = $FakeBoundParameters['subDomain']

      # To complete resources you have to provide the area first
      $area =  $FakeBoundParameters['area']

      $p = @{}

      # Use the sub domain if provided to filter the results.
      if ($subDomain) {
         $p['subDomain'] = $subDomain
      }

      if ($ParameterName -eq 'Area') {
         $areas = $(Get-VSTeamOption @p | Select-Object Area | Sort-Object -Property Area -Unique)

         foreach ($a in $areas) {
            if ($a.area -like "$WordToComplete*") {
               $results.Add([CompletionResult]::new($a.area))
            }
         }
      }
      elseif ($ParameterName -eq 'Resource' -and $area) {
         $resources = $(Get-VSTeamOption @p | Where-Object area -eq $area | Select-Object -Property resourceName | Sort-Object -Property resourceName -Unique)

         foreach ($r in $resources) {
            if ($r.resourceName -like "$WordToComplete*") {
               $results.Add([CompletionResult]::new($r.resourceName))
            }
         }
      }

      return $results
   }
}
