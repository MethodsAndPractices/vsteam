function Remove-VSTeamGitRepository {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
   param(
      [parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
      [guid[]] $Id,
      [switch] $Force
   )

   Process {
      foreach ($item in $id) {
         if ($Force -or $pscmdlet.ShouldProcess($item, "Delete Repository")) {
            try {
               _callAPI -Method Delete -Id $item -Area git -Resource repositories -Version $([VSTeamVersions]::Git) | Out-Null

               Write-Output "Deleted repository $item"
            }
            catch {
               _handleException $_
            }
         }
      }
   }
}