# Update an existing classification node.
#
# Get-VSTeamOption 'wit' 'classificationNodes'
# id              : 5a172953-1b41-49d3-840a-33f79c3ce89f
# area            : wit
# resourceName    : classificationNodes
# routeTemplate   : {project}/_apis/{area}/{resource}/{structureGroup}/{*path}
# https://bit.ly/Update-VSTeamClassificationNode

function Update-VSTeamIteration {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Medium",
      HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Update-VSTeamIteration')]
   param(
      [Parameter(Mandatory = $false)]
      [string] $Name,

      [Parameter(Mandatory = $true)]
      [string] $Path,

      [Parameter(Mandatory = $false)]
      [Nullable[datetime]] $StartDate,

      [Parameter(Mandatory = $false)]
      [Nullable[datetime]] $FinishDate,

      [switch] $Force,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName
   )

   process {

      if ($Force -or $pscmdlet.ShouldProcess('', "Update Iteration")) {

         $resp = Update-VSTeamClassificationNode -ProjectName $ProjectName `
            -Name $Name `
            -StructureGroup iterations `
            -Path $Path `
            -StartDate $StartDate `
            -FinishDate $FinishDate `
            -Force

         Write-Output $resp
      }
   }
}