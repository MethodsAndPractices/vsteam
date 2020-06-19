function Add-VSTeamKubernetesEndpoint {
   [CmdletBinding()]
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
        
      [ProjectValidateAttribute()]
      [ArgumentCompleter([ProjectCompleter])]
      [Parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
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

      return Add-VSTeamServiceEndpoint `
         -ProjectName $ProjectName `
         -endpointName $endpointName `
         -endpointType 'kubernetes' `
         -object $obj
   }
}