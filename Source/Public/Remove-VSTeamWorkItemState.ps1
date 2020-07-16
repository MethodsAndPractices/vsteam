
function Remove-VsteamWorkItemState {
   [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact='High')]
   param(
      [parameter(ValueFromPipelineByPropertyName=$true)]
      [ProcessValidateAttribute()]
      [ArgumentCompleter([ProcessTemplateCompleter])]
      $ProcessTemplate = $env:TEAM_PROCESS,

      [parameter(Mandatory = $true,ValueFromPipelineByPropertyName=$true)]
      [ArgumentCompleter([WorkItemTypeCompleter])]
      $WorkItemType,

      [Parameter(ValueFromPipelineByPropertyName=$true,Position=0)]
      $Name,

      [Switch]$Force
   )
   Process {
      foreach ($n in $Name) {
         $resp  = Get-VSTeamWorkItemType -ProcessTemplate $ProcessTemplate -WorkItemType $WorkItemType -Expand states
         $state   = $resp.states| Where-Object {$_.Name -like $n -and $_.customizationType -eq 'custom'}
         if (-not $State) {
            Write-Warning "'$n' does not  match a custom state for the WorkItem type '$WorkItemType'."
         }
         elseif ($Force -or $PSCmdlet.ShouldProcess($state.name,"Modify Work Item '$WorkItemType' in process template '$ProcessTemplate'; delete state")) {
            $url = $resp.url + "/states/$($state.id)?api-version=" + (_getApiVersion Processes) 
            _callAPI -Url $url -method Delete 
         }
      }
   }
}
