# Create a service endpoint.
#
# Get-VSTeamOption 'distributedtask' 'serviceendpoints'
# id              : dca61d2f-3444-410a-b5ec-db2fc4efb4c5
# area            : distributedtask
# resourceName    : serviceendpoints
# routeTemplate   : {project}/_apis/{area}/{resource}/{endpointId}
# https://bit.ly/Add-VSTeamServiceEndpoint

function Add-VSTeamKubernetesEndpoint {
   [CmdletBinding(HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Add-VSTeamKubernetesEndpoint')]
   param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $endpointName,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $kubeconfig,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $kubernetesUrl,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $clientCertificateData,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $clientKeyData,

      [switch] $acceptUntrustedCerts,

      [switch] $generatePfx,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName
   )

   process {
      # Process switch parameters
      $untrustedCerts = $false
      if ($acceptUntrustedCerts.IsPresent) {
         $untrustedCerts = $true
      }

      $pfx = $false
      if ($generatePfx.IsPresent) {
         $pfx = $true
      }

      $obj = @{
         authorization = @{
            parameters = @{
               clientCertificateData = $clientCertificateData
               clientKeyData         = $clientKeyData
               generatePfx           = $pfx
               kubeconfig            = $Kubeconfig
            };
            scheme     = 'None'
         };
         data          = @{
            acceptUntrustedCerts = $untrustedCerts
         };
         url           = $kubernetesUrl
      }

      return Add-VSTeamServiceEndpoint -ProjectName $ProjectName `
         -endpointName $endpointName `
         -endpointType kubernetes `
         -object $obj
   }
}