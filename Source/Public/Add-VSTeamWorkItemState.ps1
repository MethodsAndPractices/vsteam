function Add-VSTeamWorkItemState {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
   param(
      [parameter(ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProcessTemplateValidateAttribute()]
      [ArgumentCompleter([vsteam_lib.ProcessTemplateCompleter])]
      $ProcessTemplate = $env:TEAM_PROCESS,

      [parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, Position = 0)]
      [ArgumentCompleter([vsteam_lib.WorkItemTypeCompleter])]
      $WorkItemType,

      [parameter(Mandatory = $true, Position = 1)]
      [string]$Name,

      [ValidateSet('Proposed', 'InProgress', 'Resolved', 'Completed', 'Removed')]
      [string]$StateCategory = 'InProgress',

      [ArgumentCompleter([vsteam_lib.ColorCompleter])]
      [vsteam_lib.ColorTransformToHexAttribute()]
      [string]$Color = '7f7f7f',

      [int]$Order,

      [switch]$Force
   )
   process {
      #Allow the -workitemType parameter to be a wild card -for each workItem type to be updated...
      foreach ($result in (Get-VSTeamWorkItemType -ProcessTemplate $ProcessTemplate -WorkItemType $WorkItemType)) {
         if ($Force -or $PSCmdlet.ShouldProcess("$($result.name) in process template '$ProcessTemplate'", "Add new state '$name' to WorkItem type")) {
            # if it  is a system one we need to make it an inherited one
            
            if ($result.customization -eq 'system') {
               $url = ($result.url -replace '/workItemTypes/.*$', '/workItemTypes?api-version=') + (_getApiVersion Processes)
               $body = @{
                  color        = $result.color
                  description  = $result.description
                  icon         = $result.icon
                  inheritsFrom = $result.referenceName
                  isDisabled   = $result.isDisabled
                  name         = $result.name
               }
               $result = _callAPI -Url $url -method Post -ContentType   "application/json" -body (ConvertTo-Json $body)
            }
            $url = $result.url + '/states?api-version=' + (_getApiVersion Processes)
         
            $body = @{'stateCategory' = $StateCategory
               'name'                 = $Name
               'color'                = $Color
            }
         
            if ($PSBoundParameters.ContainsKey('Order')) {
               $body['order'] = $Order 
            }
         
            $resp = _callAPI -Url $url -method Post -ContentType "application/json" -body (ConvertTo-Json $body)
         
            $resp.psobject.TypeNames.Insert(0, 'vsteam_lib.WorkItemState')
            Add-Member -InputObject $resp -MemberType NoteProperty -Name ProcessTemplate -Value $ProcessTemplate
            Add-Member -InputObject $resp -MemberType NoteProperty -Name WorkItemType    -Value $result.name 

            Write-Output $resp
         }
      }
   }
}