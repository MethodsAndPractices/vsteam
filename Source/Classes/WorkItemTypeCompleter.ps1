using namespace System.Collections
using namespace System.Collections.Generic
using namespace System.Management.Automation

class WorkItemTypeCompleter : IArgumentCompleter {
   [IEnumerable[CompletionResult]] CompleteArgument(
      [string] $CommandName,
      [string] $ParameterName,
      [string] $WordToComplete,
      [Language.CommandAst] $CommandAst,
      [IDictionary] $FakeBoundParameters) {

      $workitemTypeNames = $null
      $results = [List[CompletionResult]]::new()
      
      # If the user has added the -ProcessTemplate parameter,
      # get Names of WorkItem types by process, otherwise get them by project
      if ($FakeBoundParameters['ProcessTemplate']) {
         $workitemTypeNames = [VSTeamWorkItemTypeCache]::GetByProcess($FakeBoundParameters['ProcessTemplate']) | 
         Select-Object -ExpandProperty name | Sort-Object
      }
      else {
         # if the ProjectName parameter either was the default or was omitted,
         # then use the cached list of WorkItem-type names for the default project.
         # If a non-default project was specified, then get the names for that project
         $projectName = $FakeBoundParameters['ProjectName']
         
         if (-not $projectName -or $ProjectName -eq (_getDefaultProject) ) { 
            $workitemTypeNames = [VSTeamWorkItemTypeCache]::GetCurrent() | 
            Select-Object -ExpandProperty Name | Sort-Object
         }
         else {
            # if projectname -and $ProjectName -ne _getDefaultProject
            $workitemTypeNames = Get-VSTeamWorkItemType -ProjectName $projectName | Where-Object { -Not $_.hidden } | 
            Select-Object -ExpandProperty name | Sort-Object
         }
      }
      
      $wildCard = $WordToComplete -replace "^'?(.*)'?$", '*$1*' 
      
      foreach ($value in ($workitemTypeNames | Where-Object { $_ -like $wildCard } )) {         
         $results.Add([CompletionResult]::new("'$($value.replace("'","''"))'", $value, 0, $value))
      }

      return $results
   }
}