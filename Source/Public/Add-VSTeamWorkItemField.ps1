function Add-VSTeamWorkItemField {
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
      #Get the workitem type(s) we are updating. We get a system one, make it an inherited one
      $wit = Get-VSTeamWorkItemType -ProcessTemplate $ProcessTemplate -WorkItemType $WorkItemType
      $wit = $wit | Unlock-VsteamWorkItemType -Force:$Force
      foreach ($w in $wit) {
         $url = $w.url +"/fields?api-version=" + (_getApiVersion Processes)
         foreach ($r in $ReferenceName) {
            if ($r.psobject.Properties["referenceName"]) {$r = $r.referenceName}
            $body    =  @{
                  referenceName = $r
                  defaultValue  = $DefaultValue;
                  allowGroups   = $AllowGroups -as [bool]
                  required      = $Required    -as [bool]
                  readOnly      = $ReadOnly    -as [bool]
            }

            if ($Force -or $PSCmdlet.ShouldProcess($WorkItemType, "Add field '$r' to WorkItem type" )) {
               #Call the REST API
               $resp = _callAPI -Url $url -method Post -body (ConvertTo-Json $body)

               # Apply a Type Name so we can use custom format view and/or custom type extensions
               # and add members to make it easier if piped into something which takes values by property name
               $resp.psobject.TypeNames.Insert(0,'vsteam_lib.WorkitemField')
               Add-Member -InputObject $resp -MemberType NoteProperty  -Name WorkItemType    -Value $w.name
               Add-Member -InputObject $resp -MemberType NoteProperty  -Name ProcessTemplate -Value $ProcessTemplate

               return $resp
            }
         }
      }
   }
}
