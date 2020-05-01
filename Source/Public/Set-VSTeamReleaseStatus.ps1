function Set-VSTeamReleaseStatus {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Medium")]
   param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [int[]] $Id,

      [ValidateSet('Active', 'Abandoned')]
      [string] $Status,

      # Forces the command without confirmation
      [switch] $Force
   )

   DynamicParam {
      _buildProjectNameDynamicParam
   }

   Process {
      Write-Debug 'Set-VSTeamReleaseStatus Process'

      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      $body = '{ "id": ' + $id + ', "status": "' + $status + '" }'

      foreach ($item in $id) {
         if ($force -or $pscmdlet.ShouldProcess($item, "Set status on Release")) {
            Write-Debug 'Set-VSTeamReleaseStatus Call the REST API'

            try {
               # Call the REST API
               _callAPI -Method Patch -SubDomain vsrm -Area release -Resource releases -projectName $ProjectName -id $item `
                  -body $body -ContentType 'application/json' -Version $(_getApiVersion Release) | Out-Null

               Write-Output "Release $item status changed to $status"
            }
            catch {
               _handleException $_
            }
         }
      }
   }
}