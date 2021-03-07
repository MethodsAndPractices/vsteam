function Remove-VSTeamBuild {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High",
    HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Remove-VSTeamBuild')]
   param(
      [parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
      [Alias('BuildID')]
      [int[]] $Id,

      [switch] $Force,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName
   )
   process {
      foreach ($item in $id) {
         if ($Force -or $pscmdlet.ShouldProcess($item, "Delete Build")) {
            try {
               _callAPI -Method DELETE -ProjectName $ProjectName `
                  -Area build `
                  -Resource builds `
                  -id $item `
                  -Version $(_getApiVersion Build) | Out-Null

               Write-Output "Deleted build $item"
            }
            catch {
               _handleException $_
            }
         }
      }
   }
}
