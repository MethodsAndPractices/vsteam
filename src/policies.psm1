Set-StrictMode -Version Latest

# Load common code
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$here\common.ps1"

# Apply types to the returned objects so format and type files can
# identify the object and act on it.
function _applyTypes {
   param($item)

   $item.PSObject.TypeNames.Insert(0, 'Team.Policy')
}

function Get-VSTeamPolicy {
   [CmdletBinding()]
   param (
      [Parameter(ValueFromPipeline = $true)]
      [int[]] $Id
   )

   DynamicParam {
      _buildProjectNameDynamicParam -mandatory $true
   }

   process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]
      if($id) {
         foreach ($item in $id) {
            try {
               $resp = _callAPI -ProjectName $ProjectName -Id $item -Area policy -Resource configurations -Version $VSTeamVersionTable.Git
   
               _applyTypes -item $resp
   
               Write-Output $resp   
            }
            catch {
               throw $_
            }
         }
      }
      else {
         try {
            $resp = _callAPI -ProjectName $ProjectName -Area policy -Resource configurations -Version $VSTeamVersionTable.Git

            # Apply a Type Name so we can use custom format view and custom type extensions
            foreach ($item in $resp.value) {
               _applyTypes -item $item
            }

            Write-Output $resp.value
         }
         catch {
            throw $_
         }
      }
   }
}

function Add-VSTeamPolicy {
   [CmdletBinding()]
   param(
      [Parameter(Mandatory = $true)]
      [guid] $type,
      
      [switch]
      $enabled,

      [switch]
      $blocking,

      [Parameter(Mandatory = $true)]
      $settings
   )

   DynamicParam {
      _buildProjectNameDynamicParam -mandatory $true
   }

   process {
      $ProjectName = $PSBoundParameters["ProjectName"]

      $body = @{
         isEnabled = $enabled.IsPresent;
         isBlocking = $blocking.IsPresent;
         type = @{
            id = $type
         };
         settings = $settings
      } | ConvertTo-Json -Depth 10 -Compress

      Write-Debug "Body value:"
      Write-Debug $body

      try {
         # Call the REST API
         $resp = _callAPI -ProjectName $ProjectName -Area 'policy' -Resource 'configurations' `
            -Method Post -ContentType 'application/json' -Body $body -Version $VSTeamVersionTable.Git

         Write-Output $resp
      }
      catch [System.Net.WebException] {
         _handleException $_
      }
      catch {
         # Dig into the exception to get the Response details.
         # Note that value__ is not a typo.
         $errMsg = "Failed`nStatusCode: $($_.Exception.Response.StatusCode.value__)`nStatusDescription: $($_.Exception.Response.StatusDescription)"
         Write-Error $errMsg

         throw $_
      }
   }
}

function Update-VSTeamPolicy {
   [CmdletBinding()]
   param(
      [Parameter(Mandatory = $true)]
      [int] $id,
      
      [Parameter(Mandatory = $false)]
      [guid] $type,

      [switch]
      $enabled,

      [switch]
      $blocking,

      [Parameter(Mandatory = $true)]
      $settings
   )

   DynamicParam {
      _buildProjectNameDynamicParam -mandatory $true
   }

   process {
      $ProjectName = $PSBoundParameters["ProjectName"]

      if(-not $type) {
         $policy = Get-VSTeamPolicy -ProjectName $ProjectName -Id $id | Select-Object -First 1
         $type = $policy.type.id
      }

      $body = @{
         isEnabled = $enabled.IsPresent;
         isBlocking = $blocking.IsPresent;
         type = @{
            id = $type
         }
         settings = $settings
      } | ConvertTo-Json -Depth 10 -Compress

      Write-Debug "Body value:"
      Write-Debug $body

      try {
         # Call the REST API
         $resp = _callAPI -ProjectName $ProjectName -Area 'policy' -id $id -Resource 'configurations' `
            -Method Put -ContentType 'application/json' -Body $body -Version $VSTeamVersionTable.Git

         Write-Output $resp
      }
      catch [System.Net.WebException] {
         _handleException $_
      }
      catch {
         # Dig into the exception to get the Response details.
         # Note that value__ is not a typo.
         $errMsg = "Failed`nStatusCode: $($_.Exception.Response.StatusCode.value__)`nStatusDescription: $($_.Exception.Response.StatusDescription)"
         Write-Error $errMsg

         throw $_
      }
   }
}
function Get-VSTeamPolicyType {
   [CmdletBinding()]
   param (
      [Parameter(ValueFromPipeline = $true)]
      [guid[]] $Id
   )

   DynamicParam {
      _buildProjectNameDynamicParam -mandatory $true
   }

   process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]
      
      if ($id) {
         foreach ($item in $id) {
            try {
               $resp = _callAPI -ProjectName $ProjectName -Id $item -Area policy -Resource types -Version $VSTeamVersionTable.Git
               
               _applyTypes -item $resp
               
               Write-Output $resp 
            }
            catch {
               throw $_
            }
         }
      }
      else {
         try {
            $resp = _callAPI -ProjectName $ProjectName -Area policy -Resource types -Version $VSTeamVersionTable.Git

            # Apply a Type Name so we can use custom format view and custom type extensions
            foreach ($item in $resp.value) {
               _applyTypes -item $item
            }

            Write-Output $resp.value
         }
         catch {
            throw $_
         }
      }
   }
}

function Remove-VSTeamPolicy {
   [CmdletBinding(SupportsShouldProcess = $true)]
   param(
      [parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
      [int[]] $Id,
      [switch] $Force
   )

   DynamicParam {
      _buildProjectNameDynamicParam -mandatory $true
   }

   Process {
      $ProjectName = $PSBoundParameters["ProjectName"]

      foreach ($item in $id) {
         if ($Force -or $pscmdlet.ShouldProcess($item, "Delete Policy")) {
            try {
               _callAPI -ProjectName $ProjectName -Method Delete -Id $item -Area policy -Resource configurations -Version $VSTeamVersionTable.Git | Out-Null

               Write-Output "Deleted policy $item"
            }
            catch [System.Net.WebException] {
               _handleException $_
            }
            catch {
               # Dig into the exception to get the Response details.
               # Note that value__ is not a typo.
               $errMsg = "Failed`nStatusCode: $($_.Exception.Response.StatusCode.value__)`nStatusDescription: $($_.Exception.Response.StatusDescription)"
               Write-Error $errMsg

               throw $_
            }
         }
      }
   }
}

Export-ModuleMember `
   -Function Get-VSTeamPolicy, Get-VSTeamPolicyType, Add-VSTeamPolicy, Update-VSTeamPolicy, Remove-VSTeamPolicy