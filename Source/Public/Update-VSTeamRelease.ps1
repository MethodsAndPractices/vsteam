function Update-VSTeamRelease {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Medium")]
   param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [int] $Id,

      [Parameter(Mandatory = $true)]
      [PSCustomObject] $Release,

      [switch] $Force
   )

   DynamicParam {
      _buildProjectNameDynamicParam
   }

   Process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      $body = $Release | ConvertTo-Json -Depth 99

      if ($Force -or $pscmdlet.ShouldProcess($Id, "Update Release")) {
         # Call the REST API
         $resp = _callAPI -ProjectName $projectName -SubDomain vsrm -Area release -Resource releases -Id $id  `
            -Method Put -ContentType 'application/json' -body $body -Version $([VSTeamVersions]::Release)

         Write-Output $resp
      }
   }
}