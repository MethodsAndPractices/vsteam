
function Hide-VsteamWorkItemState {
   [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact='High')]
   param(
      [parameter(ValueFromPipelineByPropertyName=$true)]
      [vsteam_lib.ProcessTemplateValidateAttribute()]
      [ArgumentCompleter([vsteam_lib.ProcessTemplateCompleter])]
      $ProcessTemplate = $env:TEAM_PROCESS,

      [parameter(Mandatory = $true,ValueFromPipelineByPropertyName=$true, Position=0)]
      [ArgumentCompleter([vsteam_lib.WorkItemTypeCompleter])]
      $WorkItemType,

      [Parameter(ValueFromPipeline=$true,Mandatory=$true,ValueFromPipelineByPropertyName=$true,position=0)]
      $Name,

      [Switch]$Force
   )
   process {
      # WorkitemType can be a wildcard and we might have an array or wildcard in Name, 
      # so get matching WorkItemTypes, loop through them and through names, get matching states(s) and loop through those.
      foreach ($result in (Get-VSTeamWorkItemType -ProcessTemplate $ProcessTemplate -WorkItemType $WorkItemType -Expand states)){
         foreach ($n in $Name) {
            #Check we have at least one matching state
            $state = $result.states| Where-Object {$_.Name -like $n -and $_.customizationType -eq 'system'}
            if (-not $State) {
               Write-Warning "'$n' does not match a system state for the WorkItem type '$($result.name)'."
            }
            else {
               foreach ($s in $state) {
                  # Hidden states have a second version to hide between so check that doesn't exist for each found state
                  if ($resp.states| Where-Object {$_.Name -eq $s.Name -and $_.hidden}) {
                     Write-Warning "'$($s.name)' is already hidden for the WorkItem type '$($result.name)'."
                  }
                  elseif ($Force -or $PSCmdlet.ShouldProcess("$($result.name) in process template '$ProcessTemplate'", "Hide state '$($s.name)' from WorkItem type")) {
                     $url  = "{0}/states/{1}?api-version={2}" -f $result.url, $s.id, (_getApiVersion Processes) 
                     $resp = _callAPI -Url $url -method Put -body '{"hidden":true}' -ContentType "application/json"
                     $resp.psobject.TypeNames.Insert(0,'vsteam_lib.WorkItemState')
                     Add-Member -InputObject $resp -MemberType NoteProperty -Name ProcessTemplate -Value $ProcessTemplate
                     Add-Member -InputObject $resp -MemberType NoteProperty -Name WorkItemType    -Value $result.name 

                     Write-Output $resp
                  }
               }
            }
         }
      }
   }
}
