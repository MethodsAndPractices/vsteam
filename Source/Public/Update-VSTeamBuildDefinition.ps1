function Update-VSTeamBuildDefinition {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Medium")]
   Param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [int] $Id,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $InFile,

      # Forces the command without confirmation
      [switch] $Force
   )

   DynamicParam {
      _buildProjectNameDynamicParam
   }

   Process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      if ($Force -or $pscmdlet.ShouldProcess($Id, "Update Build Definition")) {
         # Call the REST API
         _callAPI -Method Put -ProjectName $ProjectName -Area build -Resource definitions -Id $Id -Version $([VSTeamVersions]::Build) -InFile $InFile -ContentType 'application/json' | Out-Null
      }
   }
}