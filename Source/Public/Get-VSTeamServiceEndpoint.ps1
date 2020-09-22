function Get-VSTeamServiceEndpoint {
   [CmdletBinding(DefaultParameterSetName = 'List',
    HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Get-VSTeamServiceEndpoint')]
   param(
      [Parameter(ParameterSetName = 'ByID', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $id,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName
   )
   process {
      if ($id) {
         # Call the REST API
         $resp = _callAPI -ProjectName $ProjectName `
            -Area 'distributedtask' `
            -Resource 'serviceendpoints' `
            -Id $id `
            -Version $(_getApiVersion ServiceEndpoints)

         _applyTypesToServiceEndpoint -item $resp

         Write-Output $resp
      }
      else {
         # Call the REST API
         $resp = _callAPI -ProjectName $ProjectName `
            -Area 'distributedtask' `
            -Resource 'serviceendpoints'  `
            -Version $(_getApiVersion ServiceEndpoints)

         # Apply a Type Name so we can use custom format view and custom type extensions
         foreach ($item in $resp.value) {
            _applyTypesToServiceEndpoint -item $item
         }

         return $resp.value
      }
   }
}
