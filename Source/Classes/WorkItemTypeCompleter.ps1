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

      $results = [List[CompletionResult]]::new()

      $workitemTypes = $null

      # If the user has added the -ProcessTemplate parameter,
      # get Names of work item types by process, otherwise get them by project
      if ($FakeBoundParameters['ProcessTemplate']) {
         $workitemTypes = [VSTeamWorkItemTypeCache]::GetCurrent($FakeBoundParameters['ProcessTemplate'])
      }
      else {
         # if the ProjectName parameter either was the default or was omitted,
         # then use the cached list of WorkItem-type names for the default project.
         # If a non-default project was specified, then get the names for that project
         $projectName = $FakeBoundParameters['ProjectName']

         if (-not $projectName -or $ProjectName -eq (_getDefaultProject)) {
            $workitemTypes = [VSTeamWorkItemTypeCache]::GetCurrent($null)
         }
         else {
            # if projectname -and $ProjectName -ne _getDefaultProject
            $workitemTypes = Get-VSTeamWorkItemType -ProjectName $projectName | Where-Object { -Not $_.hidden }
         }
      }

      $workitemTypeNames = $workitemTypes | Select-Object -ExpandProperty name | Sort-Object

      $wildCard = $WordToComplete -replace "^'?(.*)'?$", '*$1*'
      foreach ($value in ($workitemTypeNames | Where-Object { $_ -like $wildCard })) {
         $results.Add([CompletionResult]::new("'$($value.replace("'","''"))'", $value, 0, $value))
      }

      return $results
   }
}