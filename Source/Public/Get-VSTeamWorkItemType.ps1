function Get-VSTeamWorkItemType {
   [CmdletBinding(DefaultParameterSetName = 'List')]
   param(
      [Parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
      [ProjectValidateAttribute()]
      [ArgumentCompleter([ProjectCompleter])]
      [string] $ProjectName,

      [parameter(ParameterSetName='Process', Mandatory = $true)]
      [ValidateProcessAttribute()]
      [ArgumentCompleter([ProcessTemplateCompleter])]
      $ProcessTemplate,

      [ArgumentCompleter([WorkItemTypeCompleter])]
      [string] $WorkItemType
   )

   Process {
      # Call the REST API
      if ($WorkItemType -and -not $ProcessTemplate) {
         $resp = _callAPI -ProjectName $ProjectName -Area 'wit' -Resource 'workitemtypes'  `
            -Version $(_getApiVersion Core) -id $WorkItemType

         # This call returns JSON with "": which causes the ConvertFrom-Json to fail.
         # To replace all the "": with "_end":
         $resp = $resp.Replace('"":', '"_end":') | ConvertFrom-Json

         _applyTypesWorkItemType -item $resp

         return $resp
      }
      elseif ($ProcessTemplate) {
         $url = (Get-VSTeamProcess -Name $ProcessTemplate).url + "/workitemtypes?api-version=" + (_getApiVersion Graph)
         $resp = (_callapi -Url $url)
         if (-not $WorkItemType)  {$WorkItemType = '*'}
         $resp.value | Where-Object {$_.name -like $workitemType} | ForEach-Object {
               $_.PSObject.TypeNames.Insert(0, 'Team.WorkItemType')
               Write-Output $_
         }
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