function Remove-VSTeamVariableGroup {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
   param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string[]] $id,

      [switch] $Force
   )

   DynamicParam {
      _buildProjectNameDynamicParam
   }

   Process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      foreach ($item in $id) {
         if ($Force -or $pscmdlet.ShouldProcess($item, "Delete Variable Group")) {
            # Call the REST API
            _callAPI -projectName $projectName -Area 'distributedtask' -Resource 'variablegroups' -Id $item  `
               -Method Delete -Version $([VSTeamVersions]::VariableGroups) | Out-Null

            Write-Output "Deleted variable group $item"
         }
      }
   }
}
