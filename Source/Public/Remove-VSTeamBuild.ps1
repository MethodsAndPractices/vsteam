function Remove-VSTeamBuild {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
   param(
      [parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
      [Alias('BuildID')]
      [int[]] $Id,

      [switch] $Force
   )

   DynamicParam {
      _buildProjectNameDynamicParam
   }

   Process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      foreach ($item in $id) {
         if ($Force -or $pscmdlet.ShouldProcess($item, "Delete Build")) {
            try {
               _callAPI -ProjectName $ProjectName -Area 'build' -Resource 'builds' -id $item `
                  -Method Delete  -Version $([VSTeamVersions]::Build) | Out-Null

               Write-Output "Deleted build $item"
            }
            catch {
               _handleException $_
            }
         }
      }
   }
}