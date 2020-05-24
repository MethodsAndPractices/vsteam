function Add-VSTeamServiceFabricEndpoint {
   [CmdletBinding(DefaultParameterSetName = 'Certificate')]
   param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [Alias('displayName')]
      [string] $endpointName,
        
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $url,

      [parameter(ParameterSetName = 'Certificate', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $certificate,

      [Parameter(ParameterSetName = 'Certificate', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [securestring] $certificatePassword,

      [parameter(ParameterSetName = 'Certificate', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [parameter(ParameterSetName = 'AzureAd', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $serverCertThumbprint,

      [Parameter(ParameterSetName = 'AzureAd', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $username,

      [Parameter(ParameterSetName = 'AzureAd', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [securestring] $password,

      [Parameter(ParameterSetName = 'None', Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
      [string] $clusterSpn,

      [Parameter(ParameterSetName = 'None', Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
      [bool] $useWindowsSecurity,

      [Parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
      [ProjectValidateAttribute()]
      [ArgumentCompleter([ProjectCompleter])]
      [string] $ProjectName
   )
   
   process {
      switch ($PSCmdlet.ParameterSetName) {
         "Certificate" {
            # copied securestring usage from Set-VSTeamAccount
            # while we don't actually have a username here, PSCredential requires that a non empty string is provided
            $credential = New-Object System.Management.Automation.PSCredential $serverCertThumbprint, $certificatePassword
            $certPass = $credential.GetNetworkCredential().Password
            $authorization = @{
               parameters = @{
                  certificate          = $certificate
                  certificatepassword  = $certPass
                  servercertthumbprint = $serverCertThumbprint
               }
               scheme     = 'Certificate'
            }
         }
         "AzureAd" {
            # copied securestring usage from Set-VSTeamAccount
            $credential = New-Object System.Management.Automation.PSCredential $username, $password
            $pass = $credential.GetNetworkCredential().Password
            $authorization = @{
               parameters = @{
                  password             = $pass
                  servercertthumbprint = $serverCertThumbprint
                  username             = $username
               }
               scheme     = 'UsernamePassword'
            }
         }
         Default {
            $authorization = @{
               parameters = @{
                  ClusterSpn         = $clusterSpn
                  UseWindowsSecurity = $useWindowsSecurity
               }
               scheme     = 'None'
            }
         }
      }

      $obj = @{
         authorization = $authorization
         data          = @{}
         url           = $url
      }

      return Add-VSTeamServiceEndpoint `
         -ProjectName $ProjectName `
         -endpointName $endpointName `
         -endpointType 'servicefabric' `
         -object $obj
   }
}