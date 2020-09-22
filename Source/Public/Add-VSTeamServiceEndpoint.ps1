# Create a service endpoint.
#
# Get-VSTeamOption 'distributedtask' 'serviceendpoints'
# id              : dca61d2f-3444-410a-b5ec-db2fc4efb4c5
# area            : distributedtask
# resourceName    : serviceendpoints
# routeTemplate   : {project}/_apis/{area}/{resource}/{endpointId}
# https://bit.ly/Add-VSTeamServiceEndpoint

function Add-VSTeamServiceEndpoint {
   [CmdletBinding(DefaultParameterSetName = 'Secure',
    HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Add-VSTeamServiceEndpoint')]
   param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $endpointName,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $endpointType,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [hashtable] $object,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName
   )
   process {
      $object['name'] = $endpointName
      $object['type'] = $endpointType

      $body = $object | ConvertTo-Json

      # Call the REST API
      $resp = _callAPI -Method POST -ProjectName $projectName `
         -Area "distributedtask" `
         -Resource "serviceendpoints" `
         -body $body `
         -Version $(_getApiVersion ServiceEndpoints)

      _trackServiceEndpointProgress -projectName $projectName -resp $resp -title 'Creating Service Endpoint' -msg "Creating $endpointName"

      return Get-VSTeamServiceEndpoint -ProjectName $ProjectName -id $resp.id
   }
}
