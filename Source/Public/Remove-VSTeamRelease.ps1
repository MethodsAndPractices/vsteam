function Remove-VSTeamRelease {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
   param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [int[]] $Id,

      # Forces the command without confirmation
      [switch] $Force
   )

   DynamicParam {
      _buildProjectNameDynamicParam
   }

   Process {
      Write-Debug 'Remove-VSTeamRelease Process'

      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      foreach ($item in $id) {
         if ($force -or $pscmdlet.ShouldProcess($item, "Delete Release")) {
            Write-Debug 'Remove-VSTeamRelease Call the REST API'

            try {
               # Call the REST API
               _callAPI -Method Delete -SubDomain vsrm -Area release -Resource releases -ProjectName $ProjectName -id $item -Version $(_getApiVersion Release) | Out-Null

               Write-Output "Deleted release $item"
            }
            catch {
               _handleException $_
            }
         }
      }
   }
}