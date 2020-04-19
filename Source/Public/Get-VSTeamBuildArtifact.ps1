function Get-VSTeamBuildArtifact {
   param(
      [parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
      [Alias('BuildID')]
      [int] $Id
   )

   DynamicParam {
      _buildProjectNameDynamicParam
   }

   Process {
      $ProjectName = $PSBoundParameters["ProjectName"]

      $resp = _callAPI -ProjectName $projectName -Area 'build' -Resource "builds/$Id/artifacts" `
         -Version $(_getApiVersion Build)

      foreach ($item in $resp.value) {
         _applyArtifactTypes -item $item
      }

      Write-Output $resp.value
   }
}