function Get-VSTeamBuildArtifact {
   param(
      [parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
      [Alias('BuildID')]
      [int] $Id,

      [Parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
      [ProjectValidateAttribute()]
      [ArgumentCompleter([ProjectCompleter])]
      [string] $ProjectName
   )
   process {
      $resp = _callAPI -ProjectName $projectName -Area 'build' -Resource "builds/$Id/artifacts" `
         -Version $(_getApiVersion Build)

      foreach ($item in $resp.value) {
         _applyArtifactTypes -item $item
      }

      Write-Output $resp.value
   }
}