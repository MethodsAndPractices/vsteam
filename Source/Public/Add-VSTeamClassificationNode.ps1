# Create new or update an existing classification node.
#
# Get-VSTeamOption 'wit' 'classificationNodes'
# id              : 5a172953-1b41-49d3-840a-33f79c3ce89f
# area            : wit
# resourceName    : classificationNodes
# routeTemplate   : {project}/_apis/{area}/{resource}/{structureGroup}/{*path}
# https://bit.ly/Add-VSTeamClassificationNode

function Add-VSTeamClassificationNode {
   [CmdletBinding(HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Add-VSTeamClassificationNode')]
   param(
      [Parameter(Mandatory = $true)]
      [string] $Name,

      [ValidateSet("areas", "iterations")]
      [Parameter(Mandatory = $true)]
      [string] $StructureGroup,

      [Parameter(Mandatory = $false)]
      [string] $Path = $null,

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
      $id = $StructureGroup

      $Path = [uri]::UnescapeDataString($Path)

      if ($Path) {
         $Path = [uri]::EscapeUriString($Path)
         $Path = $Path.TrimStart("/")
         $id += "/$Path"
      }

      $body = @{
         name = $Name
      }

      if ($StructureGroup -eq "iterations") {
         $body.attributes = @{
            startDate  = $StartDate
            finishDate = $FinishDate
         }
      }

      $bodyAsJson = $body | ConvertTo-Json -Compress -Depth 100

      # Call the REST API
      $resp = _callAPI -Method POST -ProjectName $ProjectName `
         -Area "wit" `
         -Resource "classificationnodes" `
         -id $id `
         -body $bodyAsJson `
         -Version $(_getApiVersion Core)

      $resp = [vsteam_lib.ClassificationNode]::new($resp, $ProjectName)

      Write-Output $resp
   }
}