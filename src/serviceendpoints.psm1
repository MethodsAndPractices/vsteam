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

      $body = $obj | ConvertTo-Json

      try {    
         # Call the REST API
         $resp = _callAPI -ProjectName $projectName -Area 'distributedtask' -Resource 'serviceendpoints'  `
            -Method Post -ContentType 'application/json' -body $body -Version $VSTeamVersionTable.DistributedTask
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

      _trackProgress -projectName $projectName -resp $resp -title 'Creating Service Endpoint' -msg "Creating $endpointName"

      return Get-VSTeamServiceEndpoint -ProjectName $ProjectName -id $resp.id
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
         name          = $endpointName
         type          = 'azurerm'
         url           = 'https://management.azure.com/'
      }

      $body = $obj | ConvertTo-Json
      
      # Call the REST API
      $resp = _callAPI -ProjectName $projectName -Area 'distributedtask' -Resource 'serviceendpoints'  `
         -Method Post -ContentType 'application/json' -body $body -Version $VSTeamVersionTable.DistributedTask

      _trackProgress -projectName $projectName -resp $resp -title 'Creating Service Endpoint' -msg "Creating $endpointName"

      return Get-VSTeamServiceEndpoint -ProjectName $ProjectName -id $resp.id
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
      [bool] $acceptUntrustedCerts
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
               clientCertificateData = 'sdf'
               clientKeyData = 'wer'
               generatePfx = 'false'
               kubeconfig = $Kubeconfig
            };
            scheme     = 'None'
         };
         data          = @{
            acceptUntrustedCerts = $AcceptUntrustedCerts
         };
         name          = $endpointName;
         type          = 'kubernetes';
         url           = $kubernetesUrl
      }
      $body = $obj | ConvertTo-Json

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


Set-Alias Get-ServiceEndpoint Get-VSTeamServiceEndpoint
Set-Alias Add-AzureRMServiceEndpoint Add-VSTeamAzureRMServiceEndpoint
Set-Alias Remove-ServiceEndpoint Remove-VSTeamServiceEndpoint
Set-Alias Add-SonarQubeEndpoint Add-VSTeamSonarQubeEndpoint
Set-Alias Add-KubernetesEndpoint Add-VSTeamKubernetesEndpoint

Set-Alias Remove-VSTeamAzureRMServiceEndpoint Remove-VSTeamServiceEndpoint
Set-Alias Remove-VSTeamSonarQubeEndpoint Remove-VSTeamServiceEndpoint
Set-Alias Remove-AzureRMServiceEndpoint Remove-VSTeamServiceEndpoint
Set-Alias Remove-SonarQubeEndpoint Remove-VSTeamServiceEndpoint

Export-ModuleMember `
   -Function Get-VSTeamServiceEndpoint, Add-VSTeamAzureRMServiceEndpoint, Remove-VSTeamServiceEndpoint, 
Add-VSTeamSonarQubeEndpoint, Add-VSTeamKubernetesEndpoint`
   -Alias Get-ServiceEndpoint, Add-AzureRMServiceEndpoint, Remove-ServiceEndpoint, Add-SonarQubeEndpoint, Add-KubernetesEndpoint,
Remove-VSTeamAzureRMServiceEndpoint, Remove-VSTeamSonarQubeEndpoint, Remove-AzureRMServiceEndpoint,
Remove-SonarQubeEndpoint
