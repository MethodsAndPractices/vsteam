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
      [parameter(Mandatory=$true)]
      [string] $projectName,
      [string] $id
   )

   if(-not $env:TEAM_ACCT) {
      throw 'You must call Add-TeamAccount before calling any other functions in this module.'
   }

   $version = '3.0-preview.1'
   $resource = "distributedtask/serviceendpoints"
   $instance = $env:TEAM_ACCT

   # For VSTS add defaultcollection
   if($env:TEAM_ACCT.ToLower().Contains('visualstudio.com')) {
      $instance = "$env:TEAM_ACCT/DefaultCollection"
   }

   if($id) {
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

   if($item.PSObject.Properties.Match('operationStatus').count -gt 0 -and $item.operationStatus -ne $null) {
      # This is VSTS
      $item.operationStatus.PSObject.TypeNames.Insert(0, 'Team.OperationStatus')
   }
}

function _checkStatus {
   param(
      [Parameter(Mandatory=$true)]
      [string] $uri
   )

   # Call the REST API
   $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Uri $uri -Headers @{Authorization = "Basic $env:TEAM_PAT"}

   return $resp
}

function _trackProgress {
   param(
      [Parameter(Mandatory=$true)] [string] $projectName,
      [Parameter(Mandatory=$true)] $resp,
      [string] $title,
      [string] $msg
   )

   $i = 0
   $x = 1
   $y = 10

   $url = _buildURL -projectName $projectName -id $resp.id

   # Track status
   while ($status -ne 'Failed' -and $status -ne 'Ready') {
      $status = (_checkStatus $url).operationStatus.state

      # oscillate back a forth to show progress
      $i += $x
      Write-Progress -Activity $title -Status $msg -PercentComplete ($i/$y*100)

      if($i -eq $y -or $i -eq 0) {
         $x *= -1
      }
   }
}

function Remove-ServiceEndpoint {
   [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact="High")]
   param(
      [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
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
            Invoke-RestMethod -UserAgent (_getUserAgent) -Method Delete -Uri $url -Headers @{Authorization = "Basic $env:TEAM_PAT"}

            Write-Output "Deleted service endpoint $item"
         }
      }
   }
}

function Add-AzureRMServiceEndpoint {
   [CmdletBinding()]
   param(
      [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
      [string] $displayName,
      [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
      [string] $subscriptionId,
      [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
      [string] $subscriptionTenantId,
      [string] $endpointName
   )

   DynamicParam {
      _buildProjectNameDynamicParam
   }

   Process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      # Build the url
      $url = _buildURL -projectName $projectName

      if(-not $endpointName) {
         $endpointName = $displayName
      }

      $obj = @{
         authorization=@{
            parameters=@{
               serviceprincipalid='';
               serviceprincipalkey='';
               tenantid=$subscriptionTenantId
            };
            scheme='ServicePrincipal'
         };
         data=@{
            subscriptionId=$subscriptionId;
            subscriptionName=$displayName;
            creationMode='Automatic'
         };
         name=$endpointName;
         type='azurerm';
         url='https://management.core.windows.net/'
      }

      $body = $obj | ConvertTo-Json

      # Call the REST API
      $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Method Post -Body $body -ContentType "application/json" -Uri $url -Headers @{Authorization = "Basic $env:TEAM_PAT"}

      _trackProgress -projectName $projectName -resp $resp -title 'Creating Service Endpoint' -msg "Creating $endpointName"

      return Get-ServiceEndpoint -projectName $projectName -id $resp.id
   }
}

function Get-ServiceEndpoint {
   [CmdletBinding(DefaultParameterSetName='List')]
   param(
      [Parameter(ParameterSetName='ByID', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
      [string] $id
   )

   DynamicParam {
      _buildProjectNameDynamicParam
   }

   Process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      if($id) {
         $url = _buildURL -projectName $projectName -id $id

         # Call the REST API
         $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Uri $url -Headers @{Authorization = "Basic $env:TEAM_PAT"}

         _applyTypes -item $resp

         Write-Output $resp
      } else {
         # Build the url
         $url = _buildURL -projectName $projectName

         # Call the REST API
         $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Uri $url -Headers @{Authorization = "Basic $env:TEAM_PAT"}

         # Apply a Type Name so we can use custom format view and custom type extensions
         foreach($item in $resp.value) {
            _applyTypes -item $item
         }

         return $resp.value
      }
   }
}

Export-ModuleMember -Alias * -Function Get-ServiceEndpoint, Add-AzureRMServiceEndpoint, Remove-ServiceEndpoint