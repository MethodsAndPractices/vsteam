
function Hide-VsteamWorkItemState {
   [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact='High')]
   param(
      [parameter(ValueFromPipelineByPropertyName=$true)]
      [ProcessValidateAttribute()]
      [ArgumentCompleter([ProcessTemplateCompleter])]
      $ProcessTemplate = $env:TEAM_PROCESS,

      [parameter(Mandatory = $true,ValueFromPipelineByPropertyName=$true, Position=0)]
      [ArgumentCompleter([WorkItemTypeCompleter])]
      $WorkItemType,

      [Parameter(ValueFromPipeline=$true,Mandatory=$true,ValueFromPipelineByPropertyName=$true,position=0)]
      $Name,

      [Switch]$Force
   )
   Process {
      foreach ($n in $Name) {
         $resp  = Get-VSTeamWorkItemType -ProcessTemplate $ProcessTemplate -WorkItemType $WorkItemType -Expand states
         if ($resp.states| Where-Object {$_.Name -like $n -and $_.hidden}) {
            Write-Warning "'$n' is already hidden for the WorkItem type '$WorkItemType'."
            return
         }
         $state = $resp.states| Where-Object {$_.Name -like $n -and $_.customizationType -eq 'system'}
         if (-not $State) {
            Write-Warning "'$n' does not match a system state for the WorkItem type '$WorkItemType'."
         }
         elseif ($Force -or $PSCmdlet.ShouldProcess($state.name,"Modify Work Item '$WorkItemType' in process template '$ProcessTemplate'; hide state")) {
            $url = $resp.url + "/states/$($state.id)?api-version=" + (_getApiVersion Processes) 
            $resp = _callAPI -Url $url -method Put    -body (ConvertTo-Json @{'hidden'=$true}) -ContentType "application/json"
            $resp.psobject.TypeNames.Insert(0,'Team.Workitemstate')
            Add-Member -InputObject $resp -MemberType NoteProperty -Name ProcessTemplate -Value $ProcessTemplate
            Add-Member -InputObject $resp -MemberType NoteProperty -Name WorkItemType    -Value $WorkItemType -PassThru
         }
      }
   }
}
