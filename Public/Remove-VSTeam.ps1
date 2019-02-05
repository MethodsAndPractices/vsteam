function Remove-VSTeam {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
   param(
      [Parameter(Mandatory = $True, ValueFromPipelineByPropertyName = $true)]
      [Alias('Name', 'TeamId', 'TeamName')]
      [string]$Id,

      [switch]$Force
   )
   DynamicParam {
      _buildProjectNameDynamicParam
   }

   process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      if ($Force -or $PSCmdlet.ShouldProcess($Id, "Delete team")) {
         # Call the REST API
         _callAPI -Area 'projects' -Resource "$ProjectName/teams" -Id $Id `
            -Method Delete -Version $([VSTeamVersions]::Core) | Out-Null

         Write-Output "Deleted team $Id"
      }
   }
}