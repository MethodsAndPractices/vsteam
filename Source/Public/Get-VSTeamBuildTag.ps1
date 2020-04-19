function Get-VSTeamBuildTag {
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

      # Call the REST API
      $resp = _callAPI -ProjectName $projectName -Area 'build' -Resource "builds/$Id/tags" `
         -Version $(_getApiVersion Build)

      return $resp.value
   }
}