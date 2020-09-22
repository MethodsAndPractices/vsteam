# Creates a new release definition from a JSON file.
#
# Get-VSTeamOption 'release' 'definitions' -subDomain vsrm
# id              : d8f96f24-8ea7-4cb6-baab-2df8fc515665
# area            : Release
# resourceName    : definitions
# routeTemplate   : {project}/_apis/{area}/{resource}/{definitionId}
# http://bit.ly/Add-VSTeamReleaseDefinition

function Add-VSTeamReleaseDefinition {
   [CmdletBinding(HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Add-VSTeamReleaseDefinition')]
   param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $inFile,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName
   )

   process {
      $resp = _callAPI -Method POST -subDomain "vsrm" -ProjectName $ProjectName `
         -Area "release" `
         -Resource "definitions" `
         -inFile $inFile `
         -Version $(_getApiVersion Release)

      Write-Output $resp
   }
}
