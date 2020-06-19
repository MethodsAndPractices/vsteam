function Get-VSTeamServiceEndpoint {
   [CmdletBinding(DefaultParameterSetName = 'List')]
   param(
      [Parameter(ParameterSetName = 'ByID', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $id,
      
      [Parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
      [ProjectValidateAttribute()]
      [ArgumentCompleter([ProjectCompleter])]
      [string] $ProjectName
   )
   process {
      if ($id) {
         # Call the REST API
         $resp = _callAPI -Area 'distributedtask' -Resource 'serviceendpoints' -Id $id  `
            -Version $(_getApiVersion ServiceEndpoints) -ProjectName $ProjectName

         _applyTypesToServiceEndpoint -item $resp

         Write-Output $resp
      }
      else {
         # Call the REST API
         $resp = _callAPI -ProjectName $ProjectName -Area 'distributedtask' -Resource 'serviceendpoints'  `
            -Version $(_getApiVersion ServiceEndpoints)

         # Apply a Type Name so we can use custom format view and custom type extensions
         foreach ($item in $resp.value) {
            _applyTypesToServiceEndpoint -item $item
         }

         return $resp.value
      }
   }
}
