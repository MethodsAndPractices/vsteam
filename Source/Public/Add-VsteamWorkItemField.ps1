function Add-VsteamWorkItemField {
   [CmdletBinding(SupportsShouldProcess=$True,ConfirmImpact='High')]
   param(
      [parameter(ValueFromPipelineByPropertyName=$true)]
      [vsteam_lib.ProcessTemplateValidateAttribute()]
      [ArgumentCompleter([vsteam_lib.ProcessTemplateCompleter])]
      $ProcessTemplate = $env:TEAM_PROCESS,

      [parameter(Mandatory = $true,ValueFromPipelineByPropertyName=$true, Position=0)]
      [ArgumentCompleter([vsteam_lib.WorkItemTypeCompleter])]
      $WorkItemType,

      [parameter(Mandatory = $true)]      
      [ArgumentCompleter([vsteam_lib.FieldCompleter])]
      [vsteam_lib.FieldTransformAttribute()]
      [Alias('Name','FieldName')]
      $ReferenceName,

      [string]$DefaultValue,
      [switch]$AllowGroups,
      [switch]$ReadOnly,
      [switch]$Required,
      [switch]$Force
   )
   process {
      #Get the workitem type we are updating. If it is a system one, make it an inherited one first.
      $wit = Get-VSTeamWorkItemType -ProcessTemplate $ProcessTemplate -WorkItemType $WorkItemType
      
      #$wit = [VSTeamWorkItemTypeCache]::GetByProcess($ProcessTemplate) | Where-Object name -eq $WorkItemType
      if ($wit.customization -eq 'system') {
         $url = ($wit.url -replace '/workItemTypes/.*$', '/workItemTypes?api-version=') +  (_getApiVersion Processes)
         $body = @{
               color         = $wit.color
               description   = $wit.description
               icon          = $wit.icon
               inheritsFrom  = $wit.referenceName
               isDisabled    = $wit.isDisabled
               name          = $wit.name
         }
         $wit = _callAPI -Url $url -method Post -ContentType   "application/json" -body (ConvertTo-Json $body)
      }
      $url     = $wit.url +"/fields?api-version=" + (_getApiVersion Processes)
      foreach ($r in $ReferenceName) {
         if ($r.referenceName) {$r = $r.referenceName}
         $body    =  @{ 
               referenceName = $r
               defaultValue  = $DefaultValue;
               allowGroups   = $AllowGroups -as [bool]
               required      = $Required    -as [bool]
               readOnly      = $ReadOnly    -as [bool]
         }

         if ($Force -or $PSCmdlet.ShouldProcess($WorkItemType, "Add field '$r' to WorkItem type" )) {
            $resp = _callAPI -Url $url -method Post -ContentType "application/json" -body (ConvertTo-Json $body)
            
            $resp.psobject.TypeNames.Insert(0,'vsteam_lib.WorkitemField')
            Add-Member -InputObject $resp -MemberType AliasProperty -Name WorkItemType    -Value $WorkItemType
            Add-Member -InputObject $resp -MemberType NoteProperty  -Name ProcessTemplate -Value $ProcessTemplate

            return $resp 
         }
      }
   }
}
