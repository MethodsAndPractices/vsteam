function Add-VSTeamServiceEndpoint {
   [CmdletBinding(DefaultParameterSetName = 'Secure')]
   param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $endpointName,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $endpointType,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [hashtable] $object
   )

   DynamicParam {
      _buildProjectNameDynamicParam
   }

   Process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      $object['name'] = $endpointName
      $object['type'] = $endpointType

      $body = $object | ConvertTo-Json

      # Call the REST API
      $resp = _callAPI -ProjectName $projectName -Area 'distributedtask' -Resource 'serviceendpoints'  `
         -Method Post -ContentType 'application/json' -body $body -Version $(_getApiVersion DistributedTask)

      _trackServiceEndpointProgress -projectName $projectName -resp $resp -title 'Creating Service Endpoint' -msg "Creating $endpointName"

      return Get-VSTeamServiceEndpoint -ProjectName $ProjectName -id $resp.id
   }
}