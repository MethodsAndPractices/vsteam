# Update an existing classification node.
#
# Get-VSTeamOption 'wit' 'classificationNodes'
# id              : 5a172953-1b41-49d3-840a-33f79c3ce89f
# area            : wit
# resourceName    : classificationNodes
# routeTemplate   : {project}/_apis/{area}/{resource}/{structureGroup}/{*path}
# https://bit.ly/Update-VSTeamClassificationNode

function Update-VSTeamClassificationNode {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Medium",
      HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Update-VSTeamClassificationNode')]
   param(
      [Parameter(Mandatory = $false)]
      [string] $Name,

      [ValidateSet("areas", "iterations")]
      [Parameter(Mandatory = $true)]
      [string] $StructureGroup,

      [Parameter(Mandatory = $true)]
      [string] $Path = $null,

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

      if ($Force -or $pscmdlet.ShouldProcess('', "Update Classification Node")) {

         # Call the REST API
         $resp = _callAPI -Method PATCH -ProjectName $ProjectName `
            -Area "wit" `
            -Resource "classificationnodes" `
            -id $id `
            -body $bodyAsJson `
            -Version $(_getApiVersion Core)

         $resp = [vsteam_lib.ClassificationNode]::new($resp, $ProjectName)

         Write-Output $resp
      }
   }
}