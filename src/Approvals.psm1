Set-StrictMode -Version Latest

# Load common code
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$here\common.ps1"

# Apply types to the returned objects so format and type files can
# identify the object and act on it.
function _applyTypes {
   param($item)

   $item.PSObject.TypeNames.Insert(0, 'Team.Approval')
}

function Get-VSTeamApproval {
   [CmdletBinding()]
   param(
      [Parameter()]
      [ValidateSet('Approved', 'ReAssigned', 'Rejected')]
      [string] $StatusFilter,

      [int[]] $ReleaseIdFilter,

      [string] $AssignedToFilter
   )

   DynamicParam {
      _buildProjectNameDynamicParam
   }

   Process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      try {
         # Call the REST API
         $resp = _callAPI -ProjectName $ProjectName -Area release -Resource approvals -SubDomain vsrm -Version $VSTeamVersionTable.Release `
            -QueryString @{statusFilter = $StatusFilter; assignedtoFilter = $AssignedToFilter; releaseIdFilter = ($ReleaseIdFilter -join ',')}
         
         # Apply a Type Name so we can use custom format view and custom type extensions
         foreach ($item in $resp.value) {
            _applyTypes -item $item
         }

         Write-Output $resp.value
      }
      catch {
         _handleException $_
      }
   }
}

function Show-VSTeamApproval {
   [CmdletBinding()]
   param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [Alias('Id')]
      [int] $ReleaseDefinitionId
   )

   DynamicParam {
      _buildProjectNameDynamicParam
   }

   Process {
      Write-Debug 'Show-VSTeamApproval Process'

      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      _showInBrowser "$($VSTeamVersionTable.Account)/$ProjectName/_release?releaseId=$ReleaseDefinitionId"
   }
}

function Set-VSTeamApproval {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Medium")]
   param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [int[]] $Id,

      [Parameter(Mandatory = $true)]
      [ValidateSet('Approved', 'Rejected', 'Pending', 'ReAssigned')]
      [string] $Status,

      [string] $Approver,

      [string] $Comment,

      # Forces the command without confirmation
      [switch] $Force
   )

   DynamicParam {
      _buildProjectNameDynamicParam
   }

   Process {
      Write-Debug 'Set-VSTeamApproval Process'

      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      $body = '{ "status": "' + $status + '", "approver": "' + $approver + '", "comments": "' + $comment + '" }'
      Write-Verbose $body

      foreach ($item in $id) {
         if ($force -or $pscmdlet.ShouldProcess($item, "Set Approval Status")) {
            Write-Debug 'Set-VSTeamApproval Call the REST API'

            try {
               # Call the REST API
               _callAPI -Method Patch -SubDomain vsrm -ProjectName $ProjectName -Area release -Resource approvals `
                  -Id $item -Version $VSTeamVersionTable.Release -body $body
               
               Write-Output "Approval $item status changed to $status"
            }
            catch {
               _handleException $_
            }
         }
      }
   }
}

Set-Alias Show-Approval Show-VSTeamApproval
Set-Alias Get-Approval Get-VSTeamApproval
Set-Alias Set-Approval Set-VSTeamApproval

Export-ModuleMember `
   -Function Get-VSTeamApproval, Set-VSTeamApproval, Show-VSTeamApproval `
   -Alias Show-Approval, Get-Approval, Set-Approval