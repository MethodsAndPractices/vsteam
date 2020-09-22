# Creates a new definition.
#
# Get-VSTeamOption 'build' 'Definitions'
# id              : dbeaf647-6167-421a-bda9-c9327b25e2e6
# area            : Build
# resourceName    : Definitions
# routeTemplate   : {project}/_apis/build/{resource}/{definitionId}
# https://bit.ly/Add-VSTeamBuildDefinition

function Add-VSTeamBuildDefinition {
   [CmdletBinding(HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Add-VSTeamBuildDefinition')]
   param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $InFile,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName
   )
   process {
      return _callAPI -Method POST -ProjectName $ProjectName `
         -Area "build" `
         -Resource "definitions" `
         -infile $InFile `
         -Version $(_getApiVersion Build)
   }
}
