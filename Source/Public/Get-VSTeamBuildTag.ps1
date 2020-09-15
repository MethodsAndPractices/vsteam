function Get-VSTeamBuildTag {
   [CmdletBinding()]
   param(
      [parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
      [Alias('BuildID')]
      [int] $Id,

      [Parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName
   )
   process {
      # Call the REST API
      $resp = _callAPI -ProjectName $projectName `
         -Area build `
         -Resource builds `
         -ID "$Id/tags" `
         -Version $(_getApiVersion Build)

      return $resp.value
   }
}
