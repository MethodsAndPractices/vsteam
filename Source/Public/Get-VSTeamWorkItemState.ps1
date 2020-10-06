function Get-VsteamWorkItemState {
   [CmdletBinding()]
   param(
      [parameter(ValueFromPipelineByPropertyName=$true)]
      [vsteam_lib.ProcessTemplateValidateAttribute()]
      [ArgumentCompleter([vsteam_lib.ProcessTemplateCompleter])]
      $ProcessTemplate = $env:TEAM_PROCESS,

      [parameter(Mandatory = $true,ValueFromPipelineByPropertyName=$true, Position=1)]
      [ArgumentCompleter([vsteam_lib.WorkItemTypeCompleter])]
      $WorkItemType
   )
   process {
      foreach ($result in (Get-VSTeamWorkItemType -ProcessTemplate $ProcessTemplate -WorkItemType $WorkItemType -Expand States)) {
         $resp = $result.States | Sort-Object -Property Order
         foreach ($r in $resp) {
            $r.psobject.TypeNames.Insert(0,'vsteam_lib.WorkItemState')
            Add-Member -InputObject $r -MemberType NoteProperty -Name ProcessTemplate -Value $ProcessTemplate
            Add-Member -InputObject $r -MemberType NoteProperty -Name WorkItemType    -Value $result.name 
         }
         Write-Output $resp 
      }
   }
}
