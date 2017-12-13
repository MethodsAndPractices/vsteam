Set-StrictMode -Version Latest

# Load common code
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$here\common.ps1"

$i = 0
$x = 1
$y = 10
$status = $null

function _buildURL {
   param(
      [parameter(Mandatory = $true)]
      [string] $projectName,
      [string] $id
   )

   _hasAccount

   $version = $VSTeamVersionTable.DistributedTask
   $resource = "distributedtask/serviceendpoints"
   $instance = $VSTeamVersionTable.Account

   # For VSTS add defaultcollection
   if ($VSTeamVersionTable.Account.ToLower().Contains('visualstudio.com')) {
      $instance = "$($VSTeamVersionTable.Account)/DefaultCollection"
   }

   if ($id) {
      $resource += "/$id"
   }

   # Build the url to list the projects
   return "$instance/$projectName/_apis/$($resource)?api-version=$version"
}

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

   $url = _buildURL -projectName $projectName -id $resp.id
   $isReady = $false

   # Track status
   while (-not $isReady) {
      $status = _get $url
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
         # Build the url
         $url = _buildURL -projectName $projectName -id $item

         if ($Force -or $pscmdlet.ShouldProcess($item, "Delete Service Endpoint")) {
            # Call the REST API
            _delete -url $url

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

      # Build the url
      $url = _buildURL -projectName $projectName

      $obj = @{
         authorization = @{
            parameters = @{
               username = $token;
               password = ''
            };
            scheme     = 'UsernamePassword'
         };
         data          = @{
         };
         name          = $endpointName;
         type          = 'sonarqube';
         url           = $sonarqubeUrl
      }

      $body = $obj | ConvertTo-Json

      try {
    
         # Call the REST API
         $resp = _post -url $url -body $body 
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
      
      return Get-VSTeamServiceEndpoint -projectName $projectName -id $resp.id
   }
}

function Add-VSTeamAzureRMServiceEndpoint {
   [CmdletBinding()]
   param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $displayName,
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $subscriptionId,
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $subscriptionTenantId,
      [string] $endpointName,
      [string] $servicePrincipalId,
      [string] $servicePrincipalKey
   )

   DynamicParam {
      _buildProjectNameDynamicParam
   }

   Process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      # Build the url
      $url = _buildURL -projectName $projectName

      if (-not $endpointName) {
         $endpointName = $displayName
      }

      if (-not $servicePrincipalId) {
         $creationMode = 'Automatic'
         $servicePrincipalId = ''
         $servicePrincipalKey = ''
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
            subscriptionName = $displayName
            creationMode     = $creationMode
         }
         name          = $endpointName
         type          = 'azurerm'
         url           = 'https://management.azure.com/'
      }

      $body = $obj | ConvertTo-Json
      
      # Call the REST API
      $resp = _post -url $url -body $body

      _trackProgress -projectName $projectName -resp $resp -title 'Creating Service Endpoint' -msg "Creating $endpointName"

      return Get-VSTeamServiceEndpoint -projectName $projectName -id $resp.id
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
         $url = _buildURL -projectName $projectName -id $id

         # Call the REST API
         $resp = _get -url $url

         _applyTypes -item $resp

         Write-Output $resp
      }
      else {
         # Build the url
         $url = _buildURL -projectName $projectName


         # Call the REST API
         $resp = _get -url $url
         
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

Set-Alias Remove-VSTeamAzureRMServiceEndpoint Remove-VSTeamServiceEndpoint
Set-Alias Remove-VSTeamSonarQubeEndpoint Remove-VSTeamServiceEndpoint
Set-Alias Remove-AzureRMServiceEndpoint Remove-VSTeamServiceEndpoint
Set-Alias Remove-SonarQubeEndpoint Remove-VSTeamServiceEndpoint

Export-ModuleMember `
   -Function Get-VSTeamServiceEndpoint, Add-VSTeamAzureRMServiceEndpoint, Remove-VSTeamServiceEndpoint, 
Add-VSTeamSonarQubeEndpoint `
   -Alias Get-ServiceEndpoint, Add-AzureRMServiceEndpoint, Remove-ServiceEndpoint, Add-SonarQubeEndpoint,
Remove-VSTeamAzureRMServiceEndpoint, Remove-VSTeamSonarQubeEndpoint, Remove-AzureRMServiceEndpoint,
Remove-SonarQubeEndpoint