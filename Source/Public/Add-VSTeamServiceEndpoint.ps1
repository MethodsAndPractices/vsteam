function Add-VSTeamServiceEndpoint {
   [CmdletBinding(DefaultParameterSetName = 'Secure')]
   param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $endpointName,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $endpointType,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [hashtable] $object,

      [Parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
      [ProjectValidateAttribute()]
      [ArgumentCompleter([ProjectCompleter])]
      [string] $ProjectName
   )
   process {
      $object['name'] = $endpointName
      $object['type'] = $endpointType

      $body = $object | ConvertTo-Json

      # Call the REST API
      $resp = _callAPI -ProjectName $projectName -Area 'distributedtask' -Resource 'serviceendpoints'  `
         -Method Post -ContentType 'application/json' -body $body -Version $(_getApiVersion ServiceEndpoints)

      _trackServiceEndpointProgress -projectName $projectName -resp $resp -title 'Creating Service Endpoint' -msg "Creating $endpointName"

      return Get-VSTeamServiceEndpoint -ProjectName $ProjectName -id $resp.id
   }
}
