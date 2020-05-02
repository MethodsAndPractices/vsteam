using namespace System.Collections
using namespace System.Collections.Generic
using namespace System.Management.Automation

class ResourceCompleter : IArgumentCompleter {
   [IEnumerable[CompletionResult]] CompleteArgument(
      [string] $CommandName,
      [string] $ParameterName,
      [string] $WordToComplete,
      [Language.CommandAst] $CommandAst,
      [IDictionary] $FakeBoundParameters) {

      $results = [List[CompletionResult]]::new()

      if (-not $FakeBoundParameters['Area']) {return $results}
      $Resources=@{
          'build'              =  @('builds', 'definitions')
          'Contribution'       =  @('HierarchyQuery')
          'distributedtask'    =  @('agents', 'jobrequests', 'messages', 'pools', 'queues', 'serviceendpointproxy', 'serviceendpoints', 'serviceendpointtypes', 'taskgroups', 'variablegroups')
          'git'                =  @('pullRequests', 'repositories')
          'graph'              =  @('descriptors', 'groups', 'memberships', 'users')
          'packaging'          =  @('feeds')
          'policy'             =  @('configurations', 'types')
          'process'            =  @('processes')
          'release'            =  @('approvals', 'definitions', 'releases')
          'tfvc'               =  @('branches')
          'wit'                =  @('classificationnodes', 'workitems', 'workitemtypecategories', 'workitemtypes')

      }
      $resources[$FakeBoundParameters['Area']] | Where-Object {$_ -like "$wordToComplete*"} | ForEach-Object {
           $results.Add([System.Management.Automation.CompletionResult]::new($_))
      }
      return $results
   }
}
