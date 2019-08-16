function Update-VSTeamBuildDefinition {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Medium", DefaultParameterSetName = 'JSON')]
   Param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [int] $Id,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'File')]
      [string] $InFile,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'JSON')]
      [string] $BuildDefinition,

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

         if ($InFile) {
            _callAPI -Method Put -ProjectName $ProjectName -Area build -Resource definitions -Id $Id -Version $([VSTeamVersions]::Build) -InFile $InFile -ContentType 'application/json' | Out-Null
         }
         else {
            _callAPI -Method Put -ProjectName $ProjectName -Area build -Resource definitions -Id $Id -Version $([VSTeamVersions]::Build) -Body $BuildDefinition -ContentType 'application/json' | Out-Null
         }
      }
   }
}