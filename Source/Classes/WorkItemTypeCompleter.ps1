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
      # get Names of WorkItem types by process, otherwise get them by project
      if ($FakeBoundParameters['ProcessTemplate']) {
               $workitemTypes = [VSTeamWorkItemTypeCache]::GetByProcess($FakeBoundParameters['ProcessTemplate']).name | Sort-Object
      }
      else {
         # if the ProjectName parameter  either was the default or was omitted,
         # then use the cached list of project WorkItem type-Names.
         # Otherwise get the names for the given project
         $projectName = $FakeBoundParameters['ProjectName']

         if (-not $projectName -or $projectName -eq ( _getDefaultProject) ) {
               $workitemTypes = [VSTeamWorkItemTypeCache]::GetCurrent()
         }
         else {$workitemTypes = _getWorkItemTypes -Project $projectname
         }
      }
      #The list of workitemtypes might be empty...
      foreach ($w in $workitemTypes.where({$_ -like "*$WordToComplete*"})) {
         if   ($w -notmatch '\W') {
               $results.Add([CompletionResult]::new($w))
         }
         else {
              $results.Add([CompletionResult]::new("'$($w.replace("'","''"))'", $w, 0, $w))
         }
      }
      return $results
   }
}