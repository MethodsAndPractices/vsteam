function Get-VSTeamWorkItemType {
   [CmdletBinding(DefaultParameterSetName = 'List')]
   param(
      [Parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
      [ProjectValidateAttribute()]
      [ArgumentCompleter([ProjectCompleter])]
      [string] $ProjectName,

      [Parameter()]
      [WorkItemTypeValidateAttribute()]
      [ArgumentCompleter([WorkItemTypeCompleter])]
      [string] $WorkItemType
   )

   Process {
      # Call the REST API
      if ($WorkItemType) {
         $resp = _callAPI -ProjectName $ProjectName -Area 'wit' -Resource 'workitemtypes'  `
            -Version $(_getApiVersion Core) -id $WorkItemType

         # This call returns JSON with "": which causes the ConvertFrom-Json to fail.
         # To replace all the "": with "_end":
         $resp = $resp.Replace('"":', '"_end":') | ConvertFrom-Json

         _applyTypesWorkItemType -item $resp

         return $resp
      }
      else {
         $resp = _callAPI -ProjectName $ProjectName -Area 'wit' -Resource 'workitemtypes'  `
            -Version $(_getApiVersion Core)

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