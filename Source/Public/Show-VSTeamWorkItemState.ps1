
function Show-VsteamWorkItemState {
   [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact='High')]
   param(
      [parameter(ValueFromPipelineByPropertyName=$true)]
      [ProcessValidateAttribute()]
      [ArgumentCompleter([ProcessTemplateCompleter])]
      $ProcessTemplate =  $env:TEAM_PROCESS,

      [parameter(Mandatory = $true,ValueFromPipelineByPropertyName=$true)]
      [ArgumentCompleter([WorkItemTypeCompleter])]
      [WorkItemTypeValidateAttribute()]
      $WorkItemType,

      [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
      $Name,

      [Switch]$Force
   )
   Process {
      foreach ($n in $Name) {
         $result  = Get-VSTeamWorkItemType -ProcessTemplate $ProcessTemplate -WorkItemType $WorkItemType -Expand states
         $state = $result.states| Where-Object {$_.Name -like $n -and $_.customizationType -eq 'inherited' }
         if (-not $State) {
            Write-Warning "'$n' does not  match a hidden state for the WorkItem type '$WorkItemType'."
         }
         elseif ($Force -or $PSCmdlet.ShouldProcess($n,"Modify WorkItem type '$WorkItemType' in process template '$ProcessTemplate'; show state")) {
            $url = $result.url + "/states/$($state.id)?api-version=" + (_getApiVersion Processes)
            $null = _callAPI -Url $url -method Delete  #no result to send back
         }
      }
   }
}
