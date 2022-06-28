# Update an existing classification node.
#
# Get-VSTeamOption 'wit' 'classificationNodes'
# id              : 5a172953-1b41-49d3-840a-33f79c3ce89f
# area            : wit
# resourceName    : classificationNodes
# routeTemplate   : {project}/_apis/{area}/{resource}/{structureGroup}/{*path}
# https://bit.ly/Update-VSTeamClassificationNode

function Update-VSTeamIteration {
   [CmdletBinding(HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Update-VSTeamIteration')]
   param(
      [Parameter(Mandatory = $true)]
      [string] $Name,

      [Parameter(Mandatory = $false)]
      [string] $Path,

      [Parameter(Mandatory = $false)]
      [Nullable[datetime]] $StartDate,

      [Parameter(Mandatory = $false)]
      [Nullable[datetime]] $FinishDate,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName
   )

   process {
      $resp = Update-VSTeamClassificationNode -ProjectName $ProjectName `
         -Name $Name `
         -StructureGroup iterations `
         -Path $Path `
         -StartDate $StartDate `
         -FinishDate $FinishDate

      Write-Output $resp
   }
}