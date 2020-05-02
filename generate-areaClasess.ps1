
$areas = Get-ChildItem .\Source\ -Include *.ps1 -Recurse |  select-string -Pattern "_callapi.*?-area (.*?)-"  | 
      foreach {    
         if  ($_.line -match "-resource [`"']?(\w.*?)([`"'/\s]|$)") {
            [pscustomobject]@{'Area' = ($_.matches.groups[1].value -replace "[`"']",''  -split "/")[0].trim()
                              'Resource' = $Matches[1]}
         }
      }  | Group-Object -Property area

@'
using namespace System.Collections
using namespace System.Collections.Generic
using namespace System.Management.Automation

class AreaCompleter : IArgumentCompleter {
   [IEnumerable[CompletionResult]] CompleteArgument(
      [string] $CommandName,
      [string] $ParameterName,
      [string] $WordToComplete,
      [Language.CommandAst] $CommandAst,
      [IDictionary] $FakeBoundParameters) {

      $results = [List[CompletionResult]]::new()


'@ + '      @("{0}"'  -f ($areas.name -join '", "') + @'

       ).where({$_ -like "$wordToComplete*"}) | ForEach-Object {
           $results.Add([System.Management.Automation.CompletionResult]::new($_))
      }
      return $results
   }
}
'@ > .\Source\Classes\AreaCompleter.ps1

@'
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
 
'@ + $(foreach ($a in $areas) {"         {0,-20} =  @('{1}')`r`n" -f "'$($a.name)'", (($a.group.Resource | sort-object -unique) -join "', '") }) + @'

      }
      $resources[$FakeBoundParameters['Area']] | Where-Object {$_ -like "$wordToComplete*"} | ForEach-Object {
           $results.Add([System.Management.Automation.CompletionResult]::new($_))
      }
      return $results
   }
}
'@ > .\Source\Classes\ResourceCompleter.ps1
