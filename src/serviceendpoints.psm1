Set-StrictMode -Version Latest

# Load common code
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$here\common.ps1"

$i = 0
$x = 1
$y = 10
$status = $null

# Apply types to the returned objects so format and type files can
# identify the object and act on it.
function _applyTypes {
   param($item)

   $item.PSObject.TypeNames.Insert(0, 'Team.ServiceEndpoint')

   $item.createdBy.PSObject.TypeNames.Insert(0, 'Team.User')
   $item.authorization.PSObject.TypeNames.Insert(0, 'Team.authorization')
   $item.data.PSObject.TypeNames.Insert(0, 'Team.ServiceEndpoint.Details')

   if ($item.PSObject.Properties.Match('operationStatus').count -gt 0 -and $null -ne $item.operationStatus) {
      # This is VSTS
      $item.operationStatus.PSObject.TypeNames.Insert(0, 'Team.OperationStatus')
   }
}

function _trackProgress {
   param(
      [Parameter(Mandatory = $true)] [string] $projectName,
      [Parameter(Mandatory = $true)] $resp,
      [string] $title,
      [string] $msg
   )

   $i = 0
   $x = 1
   $y = 10

   $isReady = $false

   # Track status
   while (-not $isReady) {
      $status = _callAPI -ProjectName $projectName -Area 'distributedtask' -Resource 'serviceendpoints' -Id $resp.id  `
         -Version $VSTeamVersionTable.DistributedTask

      $isReady = $status.isReady;

      if (-not $isReady) {
         $state = $status.operationStatus.state
      
         if ($state -eq "Failed") {
            throw $status.operationStatus.statusMessage
         }
      }
       
      # oscillate back a forth to show progress
      $i += $x
      Write-Progress -Activity $title -Status $msg -PercentComplete ($i / $y * 100)

      if ($i -eq $y -or $i -eq 0) {
         $x *= -1
      }
   }
}

function _supportsServiceFabricEndpoint {
   if (-not $VSTeamVersionTable.ServiceFabricEndpoint) {
       throw 'This account does not support Service Fabric endpoints.'
   } 
}

function Remove-VSTeamServiceEndpoint {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
   param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string[]] $id,

      [switch] $Force
   )

   DynamicParam {
      _buildProjectNameDynamicParam
   }

   Process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      foreach ($item in $id) {
         if ($Force -or $pscmdlet.ShouldProcess($item, "Delete Service Endpoint")) {
            # Call the REST API
            _callAPI -projectName $projectName -Area 'distributedtask' -Resource 'serviceendpoints' -Id $item  `
               -Method Delete -Version $VSTeamVersionTable.DistributedTask | Out-Null

            Write-Output "Deleted service endpoint $item"
         }
      }
   }
}

function Add-VSTeamSonarQubeEndpoint {
   [CmdletBinding(DefaultParameterSetName = 'Secure')]
   param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $endpointName,
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $sonarqubeUrl,
      [parameter(ParameterSetName = 'Plain', Mandatory = $true, Position = 2, HelpMessage = 'Personal Access Token')]
      [string] $personalAccessToken,
      [parameter(ParameterSetName = 'Secure', Mandatory = $true, HelpMessage = 'Personal Access Token')]
      [securestring] $securePersonalAccessToken
   )

   DynamicParam {
      _buildProjectNameDynamicParam
   }

   Process {    
       
      if ($personalAccessToken) {
         $token = $personalAccessToken 
      }
      else {
         $credential = New-Object System.Management.Automation.PSCredential "nologin", $securePersonalAccessToken
         $token = $credential.GetNetworkCredential().Password
      }
      
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      $obj = @{
         authorization = @{
            parameters = @{
               username = $token;
               password = ''
            };
            scheme     = 'UsernamePassword'
         };
         data          = @{};
         name          = $endpointName;
         type          = 'sonarqube';
         url           = $sonarqubeUrl
      }

      try {
         return Add-VSTeamServiceEndpoint `
            -ProjectName $ProjectName `
            -endpointName $endpointName `
            -endpointType 'azurerm' `
            -object $obj
      }
      catch [System.Net.WebException] {
         if ($_.Exception.status -eq "ProtocolError") {
            $errorDetails = ConvertFrom-Json $_.ErrorDetails
            [string] $message = $errorDetails.message
            if ($message.StartsWith("Endpoint type couldn't be recognized 'sonarqube'")) {
               Write-Error -Message "The Sonarqube extension not installed. Please install from https://marketplace.visualstudio.com/items?itemName=SonarSource.sonarqube"
               return
            }
         }
         throw
      }
   }
}

function Add-VSTeamAzureRMServiceEndpoint {
   [CmdletBinding(DefaultParameterSetName = 'Automatic')]
   param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [Alias('displayName')]
      [string] $subscriptionName,
      [Parameter(ParameterSetName = 'Automatic', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [parameter(ParameterSetName = 'Manual', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $subscriptionId,
      [Parameter(ParameterSetName = 'Automatic', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [parameter(ParameterSetName = 'Manual', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $subscriptionTenantId,
      [Parameter(ParameterSetName = 'Manual', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $servicePrincipalId,
      [Parameter(ParameterSetName = 'Manual', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $servicePrincipalKey,
      [string] $endpointName
   )

   DynamicParam {
      _buildProjectNameDynamicParam
   }

   Process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

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

function Add-VSTeamKubernetesEndpoint {
   [CmdletBinding(DefaultParameterSetName = 'Secure')]
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
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [bool] $acceptUntrustedCerts,
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [bool] $generatePfx

   )

   DynamicParam {
      _buildProjectNameDynamicParam
   }

   Process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      $obj = @{
         authorization = @{
            parameters = @{
               clientCertificateData = $clientCertificateData
               clientKeyData = $clientKeyData
               generatePfx = $generatePfx
               kubeconfig = $Kubeconfig
            };
            scheme     = 'None'
         };
         data          = @{
            acceptUntrustedCerts = $acceptUntrustedCerts
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
      [bool] $useWindowsSecurity
   )

   DynamicParam {
      _buildProjectNameDynamicParam
   }

   Process {

      # This will throw if this account does not support ServiceFabricEndpoint
      _supportsServiceFabricEndpoint

      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      switch ($PSCmdlet.ParameterSetName) {
         "Certificate" { 
            # copied securestring usage from Add-VSTeamAccount
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
            # copied securestring usage from Add-VSTeamAccount
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
         name          = $endpointName
         type          = 'servicefabric'
         url           = $url
      }

      return Add-VSTeamServiceEndpoint `
         -ProjectName $ProjectName `
         -endpointName $endpointName `
         -endpointType 'servicefabric' `
         -object $obj
   }
}

function Get-VSTeamServiceEndpoint {
   [CmdletBinding(DefaultParameterSetName = 'List')]
   param(
      [Parameter(ParameterSetName = 'ByID', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $id
   )

   DynamicParam {
      _buildProjectNameDynamicParam
   }

   Process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      if ($id) {
         # Call the REST API
         $resp = _callAPI -Area 'distributedtask' -Resource 'serviceendpoints' -Id $id  `
            -Version $VSTeamVersionTable.DistributedTask -ProjectName $ProjectName
         
         _applyTypes -item $resp

         Write-Output $resp
      }
      else {
         # Call the REST API
         $resp = _callAPI -ProjectName $ProjectName -Area 'distributedtask' -Resource 'serviceendpoints'  `
            -Version $VSTeamVersionTable.DistributedTask
         
         # Apply a Type Name so we can use custom format view and custom type extensions
         foreach ($item in $resp.value) {
            _applyTypes -item $item
         }

         return $resp.value
      }
   }
}

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

      try {    
         # Call the REST API
         $resp = _callAPI -ProjectName $projectName -Area 'distributedtask' -Resource 'serviceendpoints'  `
            -Method Post -ContentType 'application/json' -body $body -Version $VSTeamVersionTable.DistributedTask
      }
      catch [System.Net.WebException] {
         throw
      }

      _trackProgress -projectName $projectName -resp $resp -title 'Creating Service Endpoint' -msg "Creating $endpointName"

      return Get-VSTeamServiceEndpoint -ProjectName $ProjectName -id $resp.id
   }
}

function Update-VSTeamServiceEndpoint {
   [CmdletBinding(DefaultParameterSetName = 'Secure')]
   param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $id,
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [hashtable] $object
   )

   DynamicParam {
      _buildProjectNameDynamicParam
   }

   Process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      $body = $object | ConvertTo-Json

      try {    
         # Call the REST API
         $resp = _callAPI -ProjectName $projectName -Area 'distributedtask' -Resource 'serviceendpoints' -Id $id  `
            -Method Put -ContentType 'application/json' -body $body -Version $VSTeamVersionTable.DistributedTask
      }
      catch [System.Net.WebException] {
         throw
      }

      _trackProgress -projectName $projectName -resp $resp -title 'Updating Service Endpoint' -msg "Updating $id"

      return Get-VSTeamServiceEndpoint -ProjectName $ProjectName -id $id
   }
}


Set-Alias Get-ServiceEndpoint Get-VSTeamServiceEndpoint
Set-Alias Add-AzureRMServiceEndpoint Add-VSTeamAzureRMServiceEndpoint
Set-Alias Remove-ServiceEndpoint Remove-VSTeamServiceEndpoint
Set-Alias Add-SonarQubeEndpoint Add-VSTeamSonarQubeEndpoint
Set-Alias Add-ServiceFabricEndpoint Add-VSTeamServiceFabricEndpoint
Set-Alias Add-KubernetesEndpoint Add-VSTeamKubernetesEndpoint

Set-Alias Remove-VSTeamAzureRMServiceEndpoint Remove-VSTeamServiceEndpoint
Set-Alias Remove-VSTeamSonarQubeEndpoint Remove-VSTeamServiceEndpoint
Set-Alias Remove-VSTeamServiceFabricEndpoint Remove-VSTeamServiceEndpoint
Set-Alias Remove-AzureRMServiceEndpoint Remove-VSTeamServiceEndpoint
Set-Alias Remove-SonarQubeEndpoint Remove-VSTeamServiceEndpoint
Set-Alias Remove-ServiceFabricEndpoint Remove-VSTeamServiceEndpoint

Set-Alias Add-ServiceEndpoint Add-VSTeamServiceEndpoint
Set-Alias Update-ServiceEndpoint Update-VSTeamServiceEndpoint

Export-ModuleMember `
   -Function Get-VSTeamServiceEndpoint, Add-VSTeamAzureRMServiceEndpoint, Remove-VSTeamServiceEndpoint, 
Add-VSTeamSonarQubeEndpoint, Add-VSTeamServiceFabricEndpoint, Add-VSTeamKubernetesEndpoint,  Add-VSTeamServiceEndpoint, Update-VSTeamServiceEndpoint `
   -Alias Get-ServiceEndpoint, Add-AzureRMServiceEndpoint, Remove-ServiceEndpoint, Add-SonarQubeEndpoint, Add-KubernetesEndpoint,
Remove-VSTeamAzureRMServiceEndpoint, Remove-VSTeamSonarQubeEndpoint, Remove-AzureRMServiceEndpoint,
Remove-SonarQubeEndpoint, Add-ServiceFabricEndpoint, Remove-ServiceFabricEndpoint, Remove-VSTeamServiceFabricEndpoint, Add-ServiceEndpoint, Update-ServiceEndpoint
