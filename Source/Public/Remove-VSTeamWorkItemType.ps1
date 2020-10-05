function Remove-VSTeamWorkItemType {
   [CmdletBinding(DefaultParameterSetName='LeaveAlone',SupportsShouldProcess=$true,ConfirmImpact='High')]
   param(
      [parameter(Mandatory = $true,ValueFromPipelineByPropertyName=$true)]
      [vsteam_lib.ProcessTemplateValidateAttribute()]
      [ArgumentCompleter([vsteam_lib.ProcessTemplateCompleter])]
      $ProcessTemplate,

      [parameter(Mandatory = $true,ValueFromPipelineByPropertyName=$true)]
      [ArgumentCompleter([vsteam_lib.WorkItemTypeCompleter])]
      [Alias('Name')]
      $WorkItemType,

      [switch]$Force
   )
   process {
      #Get the existing workitem-type definition. Drop out if can't be found or if it is a system type 
      $wit  = Get-VSTeamWorkItemType -ProcessTemplate $ProcessTemplate -WorkItemType $WorkItemType
      if (-not $wit) {Write-Warning "'$workitemType' does not appear to be a valid Workitem type." ; return}
      elseif  ($wit.customization -eq 'System') {
          throw "'$workitemType' is a system WorkItem type and cannot be deleted (but can be disabled)." ; return
      }
      else {$url  = "$($wit.url)?api-version=" + (_getApiVersion Processes)  }
      
      if ($Force -or $PSCmdlet.ShouldProcess($WorkItemType,"Modify $ProcessTemplate to delete definition of Workitem type") ) {
         # Call the rest API - nothing to return, if this is the current process invalidate the cache of WorkItemTypeNames.
         $null =  _callapi -Url $url -method  Delete

         if ($env:TEAM_PROCESS -eq $ProcessTemplate) {[vsteam_lib.WorkItemTypeCache]::Invalidate()}
      }
   }
}