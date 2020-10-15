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
      #Get the workitem type we are updating. If it is a system one, make it an inherited one first.
      $wit = Get-VSTeamWorkItemType -ProcessTemplate $ProcessTemplate -WorkItemType $WorkItemType
      foreach ($w in $wit) {
         if ($w.customization -eq 'system') {
            $url = ($w.url -replace '/workItemTypes/.*$', '/workItemTypes?api-version=') +  (_getApiVersion Processes)
            $body = @{
                  color         = $w.color
                  description   = $w.description
                  icon          = $w.icon
                  inheritsFrom  = $w.referenceName
                  isDisabled    = $w.isDisabled
                  name          = $w.name
            }
            $w = _callAPI -Url $url -method Post -body (ConvertTo-Json $body)
         }
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
               $resp = _callAPI -Url $url -method Post -body (ConvertTo-Json $body)

               $resp.psobject.TypeNames.Insert(0,'vsteam_lib.WorkitemField')
               Add-Member -InputObject $resp -MemberType NoteProperty  -Name WorkItemType    -Value $w.name
               Add-Member -InputObject $resp -MemberType NoteProperty  -Name ProcessTemplate -Value $ProcessTemplate

               return $resp
            }
         }
   }}
}
