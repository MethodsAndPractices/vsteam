function Get-VSTeamWorkItemType {
   [CmdletBinding(DefaultParameterSetName = 'List',
    HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Get-VSTeamWorkItemType')]
   param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName,

      [Parameter()]
      [vsteam_lib.WorkItemTypeValidateAttribute()]
      [ArgumentCompleter([vsteam_lib.WorkItemTypeCompleter])]
      [string] $WorkItemType
   )

   Process {
      # Call the REST API
      $commonArgs = @{
         ProjectName = $ProjectName
         Area        = 'wit'
         Resource    = 'workitemtypes'
         Version     = $(_getApiVersion Core)
      }

      if ($WorkItemType) {
         $resp = _callAPI @commonArgs -id $WorkItemType

         # This call returns JSON with "": which causes the ConvertFrom-Json to fail.
         # To replace all the "": with "_end":
         $resp = $resp.Replace('"":', '"_end":') | ConvertFrom-Json

         _applyTypesWorkItemType -item $resp

         return $resp
      }
      else {
         $resp = _callAPI @commonArgs

         # This call returns JSON with "": which causes the ConvertFrom-Json to fail.
         # To replace all the "": with "_end":
         $resp = $resp.Replace('"":', '"_end":') | ConvertFrom-Json

         # Apply a Type Name so we can use custom format view and custom type extensions
         foreach ($item in $resp.value) {
            _applyTypesWorkItemType -item $item
         }

         return $resp.value
      }
   }
}