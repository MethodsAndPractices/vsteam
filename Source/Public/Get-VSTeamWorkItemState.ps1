function Get-VsteamWorkItemState {
   [CmdletBinding()]
   param(
      [parameter(ValueFromPipelineByPropertyName=$true)]
      [ProcessValidateAttribute()]
      [ArgumentCompleter([ProcessTemplateCompleter])]
      $ProcessTemplate = $env:TEAM_PROCESS,

      [parameter(Mandatory = $true,ValueFromPipelineByPropertyName=$true, Position=1)]
      [ArgumentCompleter([WorkItemTypeCompleter])]
      $WorkItemType
   )
   process {
      $resp = (Get-VSTeamWorkItemType -ProcessTemplate $ProcessTemplate -WorkItemType $WorkItemType -Expand States).States | Sort-Object -Property Order
      foreach ($r in $resp) {
         $r.psobject.TypeNames.Insert(0,'Team.Workitemstate')
         Add-Member -InputObject $r -MemberType NoteProperty -Name ProcessTemplate -Value $ProcessTemplate
         Add-Member -InputObject $r -MemberType NoteProperty -Name WorkItemType    -Value $WorkItemType -PassThru      
      }
   }
}
