function Remove-VSTeamWorkItemType {
   [CmdletBinding(DefaultParameterSetName='LeaveAlone',SupportsShouldProcess=$true,ConfirmImpact='High')]
   param(
      [parameter(Mandatory = $true,ValueFromPipelineByPropertyName=$true)]
      [ProcessValidateAttribute()]
      [ArgumentCompleter([ProcessTemplateCompleter])]
      $ProcessTemplate,

      [parameter(Mandatory = $true,ValueFromPipelineByPropertyName=$true)]
      [ArgumentCompleter([WorkItemTypeCompleter])]
      [Alias('Name')]
      $WorkItemType,

      [switch]$Force
   )
   process {
      $wit  = [VSTeamWorkItemTypeCache]::GetCurrent($ProcessTemplate ) | Where-Object -Property name -eq  $WorkItemType
     if (-not $wit) {Write-Warning "'$workitemType' does not appear to be a valid WorkItem Type." ; return}
      elseif  ($wit.customization -eq 'System') {
          throw "'$workitemType' is a system WorkItem and cannot be deleted (but can be disabled)." ; return
      }
      $url  = "$($wit.url)?api-version=" + (_getApiVersion Processes)  
      if ($Force -or $PSCmdlet.ShouldProcess($WorkItemType,"Modify $ProcessTemplate to delete definition of Workitem type") ) {
         $null =  _callapi -Url $url -method  Delete
         [VSTeamWorkItemTypeCache]::InvalidateByProcess($ProcessTemplate)
      }
   }
}