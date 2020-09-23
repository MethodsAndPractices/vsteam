function Remove-VSTeamClassificationNode {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High",
    HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Remove-VSTeamClassificationNode')]
   param(
      [Parameter(Mandatory = $false)]
      [int] $ReClassifyId,

      [ValidateSet("areas", "iterations")]
      [Parameter(Mandatory = $true)]
      [string] $StructureGroup,

      [Parameter(Mandatory = $false)]
      [string] $Path,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName,

      [switch] $Force
   )

   process {
      $id = $StructureGroup

      $Path = [uri]::UnescapeDataString($Path)

      if ($Path) {
         $Path = [uri]::EscapeUriString($Path)
         $Path = $Path.TrimStart("/")
         $id += "/$Path"
      }

      $queryString = @{ }
      if ($ReClassifyId) {
         $queryString.Add("`$ReClassifyId", $ReClassifyId)
      }

      # Call the REST API
      if ($force -or $pscmdlet.ShouldProcess($Path, "Delete classification node")) {
         $null = _callAPI -Method DELETE -ProjectName $ProjectName `
            -Area wit `
            -Resource classificationnodes `
            -id $id `
            -QueryString $queryString `
            -Version $(_getApiVersion Core)
      }
   }
}