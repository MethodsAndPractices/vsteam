function Get-VSTeamApproval {
   [CmdletBinding(HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Get-VSTeamApproval')]
   param(
      [ValidateSet('Approved', 'ReAssigned', 'Rejected', 'Canceled', 'Pending', 'Rejected', 'Skipped', 'Undefined')]
      [string] $StatusFilter,

      [Parameter(ValueFromPipelineByPropertyName = $true)]
      [int[]] $ReleaseId,

      [string] $AssignedToFilter,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName
   )

   process {
      try {
         # Build query string and determine if the includeMyGroupApprovals should be added.
         $queryString = @{statusFilter = $StatusFilter; assignedtoFilter = $AssignedToFilter; releaseIdsFilter = ($ReleaseId -join ',') }

         # The support in TFS and VSTS are not the same.
         $instance = $(_getInstance)
         if (_isVSTS $instance) {
            if ([string]::IsNullOrEmpty($AssignedToFilter) -eq $false) {
               $queryString.includeMyGroupApprovals = 'true';
            }
         }
         else {
            # For TFS all three parameters must be set before you can add
            # includeMyGroupApprovals.
            if ([string]::IsNullOrEmpty($AssignedToFilter) -eq $false -and
               [string]::IsNullOrEmpty($ReleaseId) -eq $false -and
               $StatusFilter -eq 'Pending') {
               $queryString.includeMyGroupApprovals = 'true';
            }
         }

         # Call the REST API
         $resp = _callAPI -SubDomain vsrm -ProjectName $ProjectName `
            -Area release `
            -Resource approvals `
            -QueryString $queryString `
            -Version $(_getApiVersion Release)

         # Apply a Type Name so we can use custom format view and custom type extensions
         foreach ($item in $resp.value) {
            _applyTypesToApproval -item $item
         }

         Write-Output $resp.value
      }
      catch {
         _handleException $_
      }
   }
}