function Remove-VSTeamTaskGroup {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Low")]
   param(       
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string[]] $Id,

      [switch] $Force
   )

   DynamicParam {
      _buildProjectNameDynamicParam
   }

   process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      foreach ($item in $Id) {
         if ($Force -or $pscmdlet.ShouldProcess($item, "Delete Task Group")) {
            # Call the REST API
            _callAPI -Method Delete -ProjectName $ProjectName -Area distributedtask -Resource taskgroups -Version $([VSTeamVersions]::TaskGroups) -Id $item | Out-Null

            Write-Output "Deleted task group $item"
         }
      }
   }
}