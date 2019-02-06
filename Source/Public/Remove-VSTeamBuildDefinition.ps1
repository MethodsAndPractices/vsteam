function Remove-VSTeamBuildDefinition {
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
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      foreach ($item in $id) {
         if ($Force -or $pscmdlet.ShouldProcess($item, "Delete Build Definition")) {
            # Call the REST API
            _callAPI -Method Delete -ProjectName $ProjectName -Area build -Resource definitions -Id $item -Version $([VSTeamVersions]::Build) | Out-Null

            Write-Output "Deleted build definition $item"
         }
      }
   }
}