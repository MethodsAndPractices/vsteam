function Remove-VSTeamArea {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High",
    HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Remove-VSTeamArea')]
   param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [Alias('NodeId')]
      [int] $ReClassifyId,

      [Parameter(Mandatory = $true, Position = 0)]
      [string] $Path,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName,

      [switch] $Force
   )

   process {
      if ($force -or $pscmdlet.ShouldProcess($Path, "Delete area")) {
         $null = Remove-VSTeamClassificationNode -ProjectName $ProjectName `
            -StructureGroup 'areas' `
            -Path $Path `
            -ReClassifyId $ReClassifyId `
            -Force
      }
   }
}