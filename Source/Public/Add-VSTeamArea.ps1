# Create new or update an existing classification node.
#
# Get-VSTeamOption 'wit' 'classificationNodes'
# id              : 5a172953-1b41-49d3-840a-33f79c3ce89f
# area            : wit
# resourceName    : classificationNodes
# routeTemplate   : {project}/_apis/{area}/{resource}/{structureGroup}/{*path}
# https://bit.ly/Add-VSTeamClassificationNode

function Add-VSTeamArea {
   [CmdletBinding(HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Add-VSTeamArea')]
   param(
      [Parameter(Mandatory = $true, Position = 0)]
      [string] $Name,

      [Parameter(Mandatory = $false)]
      [string] $Path,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName
   )
   process {
      $resp = Add-VSTeamClassificationNode -ProjectName $ProjectName `
         -Name $Name `
         -StructureGroup areas `
         -Path $Path

      Write-Output $resp
   }
}