function Remove-VSTeamIteration {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High",
    HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Remove-VSTeamIteration')]
   param(
      [Parameter(Mandatory = $true)]
      [int] $ReClassifyId,

      [Parameter(Mandatory = $true)]
      [string] $Path,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName,

      [switch] $Force
   )

   process {
      if ($force -or $pscmdlet.ShouldProcess($Path, "Delete iteration")) {
         $null = Remove-VSTeamClassificationNode -ProjectName $ProjectName `
            -StructureGroup 'iterations' `
            -Path $Path `
            -ReClassifyId $ReClassifyId `
            -Force
      }
   }
}