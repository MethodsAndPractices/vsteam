function Add-VSTeamAzureRMServiceEndpoint {
   [CmdletBinding(DefaultParameterSetName = 'Automatic')]
   param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [Alias('displayName')]
      [string] $subscriptionName,
        
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $subscriptionId,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $subscriptionTenantId,

      [Parameter(ParameterSetName = 'Manual', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $servicePrincipalId,

      [Parameter(ParameterSetName = 'Manual', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $servicePrincipalKey,

      [string] $endpointName,

      [ProjectValidateAttribute()]
      [ArgumentCompleter([ProjectCompleter])]
      [Parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
      [string] $ProjectName
   )
   process {
      if (-not $endpointName) {
         $endpointName = $subscriptionName
      }

      if (-not $servicePrincipalId) {
         $creationMode = 'Automatic'
      }
      else {
         $creationMode = 'Manual'
      }

      $obj = @{
         authorization = @{
            parameters = @{
               serviceprincipalid  = $servicePrincipalId
               serviceprincipalkey = $servicePrincipalKey
               tenantid            = $subscriptionTenantId
            }
            scheme     = 'ServicePrincipal'
         }
         data          = @{
            subscriptionId   = $subscriptionId
            subscriptionName = $subscriptionName
            creationMode     = $creationMode
         }
         url           = 'https://management.azure.com/'
      }

      return Add-VSTeamServiceEndpoint `
         -ProjectName $ProjectName `
         -endpointName $endpointName `
         -endpointType 'azurerm' `
         -object $obj
   }
}