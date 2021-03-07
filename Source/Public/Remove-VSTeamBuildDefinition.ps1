function Remove-VSTeamBuildDefinition {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High",
    HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Remove-VSTeamBuildDefinition')]
   param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [int[]] $Id,

      [switch] $Force,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName
   )

   process {
      foreach ($item in $id) {
         if ($Force -or $pscmdlet.ShouldProcess($item, "Delete Build Definition")) {
            # Call the REST API
            _callAPI -Method DELETE -ProjectName $ProjectName `
               -Area build `
               -Resource definitions `
               -Id $item `
               -Version $(_getApiVersion Build) | Out-Null

            Write-Output "Deleted build definition $item"
         }
      }
   }
}
