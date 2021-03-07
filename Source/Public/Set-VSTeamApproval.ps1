function Set-VSTeamApproval {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Medium",
    HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Set-VSTeamApproval')]
   param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [int[]] $Id,

      [Parameter(Mandatory = $true)]
      [ValidateSet('Approved', 'Rejected', 'Pending', 'ReAssigned')]
      [string] $Status,

      [string] $Approver,

      [string] $Comment,

      [switch] $Force,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName
   )

   process {
      $body = '{ "status": "' + $status + '", "approver": "' + $approver + '", "comments": "' + $comment + '" }'

      Write-Verbose $body

      foreach ($item in $id) {
         if ($force -or $pscmdlet.ShouldProcess($item, "Set Approval Status")) {
            try {
               # Call the REST API
               _callAPI -Method PATCH -SubDomain vsrm -ProjectName $ProjectName `
                  -Area release `
                  -Resource approvals `
                  -Id $item `
                  -body $body `
                  -Version $(_getApiVersion Release) | Out-Null

               Write-Output "Approval $item status changed to $status"
            }
            catch {
               _handleException $_
            }
         }
      }
   }
}
