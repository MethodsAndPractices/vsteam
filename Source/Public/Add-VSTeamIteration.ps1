# Create new or update an existing classification node.
#
# Get-VSTeamOption 'wit' 'classificationNodes'
# id              : 5a172953-1b41-49d3-840a-33f79c3ce89f
# area            : wit
# resourceName    : classificationNodes
# routeTemplate   : {project}/_apis/{area}/{resource}/{structureGroup}/{*path}
# https://bit.ly/Add-VSTeamClassificationNode

function Add-VSTeamIteration {
   [CmdletBinding(HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Add-VSTeamIteration')]
   param(
      [Parameter(Mandatory = $true)]
      [string] $Name,

      [Parameter(Mandatory = $false)]
      [string] $Path,

      [Parameter(Mandatory = $false)]
      [datetime] $StartDate,

      [Parameter(Mandatory = $false)]
      [datetime] $FinishDate,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName
   )

   process {
      $params = @{}

      if ($StartDate) {
         $params.StartDate = $StartDate
      }

      if ($FinishDate) {
         $params.FinishDate = $FinishDate
      }

      $resp = Add-VSTeamClassificationNode @params -ProjectName $ProjectName `
         -Name $Name `
         -StructureGroup iterations `
         -Path $Path

      Write-Output $resp
   }
}