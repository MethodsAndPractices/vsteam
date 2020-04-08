using namespace System.Collections
using namespace System.Collections.Generic
using namespace System.Management.Automation

class QueryCompleter : IArgumentCompleter {
   [IEnumerable[CompletionResult]] CompleteArgument(
      [string] $CommandName,
      [string] $ParameterName,
      [string] $WordToComplete,
      [Language.CommandAst]$CommandAst,
      [IDictionary] $FakeBoundParameters
   ) {
      $results = [List[CompletionResult]]::new()
      $projName = $FakeBoundParameters['ProjectName']
      
      if (-not $projName -and $Global:PSDefaultParameterValues["*:projectName"]) {
         $projName = $Global:PSDefaultParameterValues["*:projectName"]
      }
      
      if (-not $projName) { return $results }
      
      if ([VSTeamQueryCache]::timestamp -lt 0 -or
         [VSTeamQueryCache]::timestamp -lt [datetime]::Now.TimeOfDay.TotalMinutes - 5) {
         [VSTeamQueryCache]::queries = (Invoke-VSTeamRequest -ProjectName $projName  -Area wit -Resource queries -version ([vsteamversions]::core) -QueryString @{'$depth' = 1 }
         ).value.children | Select-Object Name, ID | Sort-Object Name
         [VSTeamQueryCache]::timestamp = (Get-Date).TimeOfDay.TotalMinutes
      }
      
      foreach ($q in [VSTeamQueryCache]::queries ) {
         if ($q.name -like "*$WordToComplete*" -and $q.name -match "[\s'\(\[#;@]") {
            $results.Add([CompletionResult]::new(('"{0}"' -f $q.name)))
         }
         elseif ($q.name -like "*$WordToComplete*") {
            $results.Add([CompletionResult]::new($q.name))
         }
      }
      
      return $results
   }
}