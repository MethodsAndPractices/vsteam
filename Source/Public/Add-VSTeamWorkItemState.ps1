function Add-VsteamWorkItemState {
   [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact='High')]
   param(
      [parameter(ValueFromPipelineByPropertyName=$true)]
      [ProcessValidateAttribute()]
      [ArgumentCompleter([ProcessTemplateCompleter])]
      $ProcessTemplate,

      [parameter(Mandatory = $true,ValueFromPipelineByPropertyName=$true, Position=0)]
      [ArgumentCompleter([WorkItemTypeCompleter])]
      $WorkItemType,

      [parameter(Mandatory = $true,Position=1)]
      [string]$Name,

      [ValidateSet('Proposed', 'InProgress', 'Resolved', 'Completed', 'Removed')]
      [string]$StateCategory = 'InProgress',

      [ArgumentCompleter([ColorCompleter])]
      [ColorTransformToHexAttribute()]
      [string]$Color = '7f7f7f',

      [int]$Order,

      [switch]$Force

   )
   process{
      if ($Force -or $PSCmdlet.ShouldProcess($name,"Modify WorkItem type '$WorkItemType' in process template '$ProcessTemplate'; Add new state")) {
         #Get the workItem type to be updated, if it  is a system one we need to make it an inherited one
         $wit =  $wit = [VSTeamWorkItemTypeCache]::GetByProcess($ProcessTemplate) | Where-Object name -eq $WorkItemType
         if ($wit.customization -eq 'system') {
            $url = ($wit.url -replace '/workItemTypes/.*$', '/workItemTypes?api-version=') +  (_getApiVersion Processes)
            $body = @{
                  color        = $wit.color
                  description  = $wit.description
                  icon         = $wit.icon
                  inheritsFrom = $wit.referenceName
                  isDisabled   = $wit.isDisabled
                  name         = $wit.name
            }
            $wit = _callAPI -Url $url -method Post -ContentType   "application/json" -body (ConvertTo-Json $body)
            [VSTeamWorkItemTypeCache]::InvalidateByProcess($ProcessTemplate)
         }
         $url = $wit.url + '/states?api-version=' + (_getApiVersion Processes)
         $body  =  @{'stateCategory'  = $StateCategory
                     'name'           = $Name
                     'color'          = $Color
         }
         if ($PSBoundParameters.ContainsKey('Order')) {$body['order'] = $Order}
         $resp = _callAPI -Url $url -method Post -ContentType   "application/json" -body (ConvertTo-Json $body)
         $resp.psobject.TypeNames.Insert(0,'Team.Workitemstate')
         Add-Member           -InputObject $resp -MemberType NoteProperty -Name ProcessTemplate -Value $ProcessTemplate
         Add-Member -PassThru -InputObject $resp -MemberType NoteProperty -Name WorkItemType    -Value $WorkItemType
      }
   }
}