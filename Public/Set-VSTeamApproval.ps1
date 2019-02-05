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
                  -Id $item -Version $([VSTeamVersions]::Release) -body $body -ContentType 'application/json' | Out-Null
               
               Write-Output "Approval $item status changed to $status"
            }
            catch {
               _handleException $_
            }
         }
      }
   }
}