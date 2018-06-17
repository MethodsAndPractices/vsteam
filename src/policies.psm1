Set-StrictMode -Version Latest

# Load common code
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$here\common.ps1"

# Apply types to the returned objects so format and type files can
# identify the object and act on it.
function _applyTypesToPolicy {
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
      if ($id) {
         foreach ($item in $id) {
            try {
               $resp = _callAPI -ProjectName $ProjectName -Id $item -Area policy -Resource configurations -Version $VSTeamVersionTable.Git
   
               _applyTypesToPolicy -item $resp
   
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
               _applyTypesToPolicy -item $item
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
         isEnabled  = $enabled.IsPresent;
         isBlocking = $blocking.IsPresent;
         type       = @{
            id = $type
         };
         settings   = $settings
      } | ConvertTo-Json -Depth 10 -Compress

      try {
         # Call the REST API
         $resp = _callAPI -ProjectName $ProjectName -Area 'policy' -Resource 'configurations' `
            -Method Post -ContentType 'application/json' -Body $body -Version $VSTeamVersionTable.Git

         Write-Output $resp
      }
      catch {
         _handleException $_
      }
   }
}

function Update-VSTeamPolicy {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Medium")]
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
      $settings,

      [switch]
      $Force
   )

   DynamicParam {
      _buildProjectNameDynamicParam -mandatory $true
   }

   process {
      $ProjectName = $PSBoundParameters["ProjectName"]

      if (-not $type) {
         $policy = Get-VSTeamPolicy -ProjectName $ProjectName -Id $id | Select-Object -First 1
         $type = $policy.type.id
      }

      $body = @{
         isEnabled  = $enabled.IsPresent;
         isBlocking = $blocking.IsPresent;
         type       = @{
            id = $type
         }
         settings   = $settings
      } | ConvertTo-Json -Depth 10 -Compress

      try {
         if ($Force -or $pscmdlet.ShouldProcess($id, "Update Policy")) {
            # Call the REST API
            $resp = _callAPI -ProjectName $ProjectName -Area 'policy' -id $id -Resource 'configurations' `
               -Method Put -ContentType 'application/json' -Body $body -Version $VSTeamVersionTable.Git

            Write-Output $resp
         }
      }
      catch {
         _handleException $_
      }
   }
}

function Remove-VSTeamPolicy {
   [CmdletBinding(SupportsShouldProcess = $true)]
   param(
      [parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
      [int[]]
      $Id,
      
      [switch]
      $Force
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
            catch {
               _handleException $_
            }
         }
      }
   }
}

Set-Alias Get-Policy Get-VSTeamPolicy
Set-Alias Add-Policy Add-VSTeamPolicy
Set-Alias Remove-Policy Remove-VSTeamPolicy
Set-Alias Update-Policy Update-VSTeamPolicy

Export-ModuleMember `
   -Function Get-VSTeamPolicy, Add-VSTeamPolicy, Update-VSTeamPolicy, Remove-VSTeamPolicy `
   -Alias Get-Policy, Add-Policy, Update-Policy, Remove-Policy 