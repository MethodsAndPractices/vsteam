
function Show-VsteamWorkItemState {
   [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact='High')]
   param(
      [parameter(ValueFromPipelineByPropertyName=$true)]
      [vsteam_lib.ProcessTemplateValidateAttribute()]
      [ArgumentCompleter([vsteam_lib.ProcessTemplateCompleter])]
      $ProcessTemplate =  $env:TEAM_PROCESS,

      [parameter(Mandatory = $true,ValueFromPipelineByPropertyName=$true)]
      [ArgumentCompleter([vsteam_lib.WorkItemTypeCompleter])]
      $WorkItemType,

      [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
      $Name,

      [Switch]$Force
   )
   Process {
      # WorkitemType can be a wildcard and we might have an array or wildcard in Name, 
      # so get matching WorkItemTypes, loop through them and through names, get matching states(s) and loop through those.
      foreach ($result in (Get-VSTeamWorkItemType -ProcessTemplate $ProcessTemplate -WorkItemType $WorkItemType -Expand states)){
         foreach ($n in $Name) {
            $state = $result.states| Where-Object {$_.Name -like $n -and $_.customizationType -eq 'inherited' }
            if (-not $State) {
               Write-Warning "'$n' does not  match a hidden state for the WorkItem type '$($result.name)'."
            }
            else {
               foreach ($s in $state) {
                  if ($Force -or $PSCmdlet.ShouldProcess("$($result.name) in process template '$ProcessTemplate'", "Show state '$($s.name)' on WorkItem type")) {
                     $url = "{0}/states/{1}?api-version={2}" -f $result.url, $s.id, (_getApiVersion Processes) 
                     $null = _callAPI -Url $url -method Delete  #no result to send back
                  }
               }
            }
         }
      }
   }
}
