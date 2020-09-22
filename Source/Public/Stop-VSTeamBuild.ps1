function Stop-VSTeamBuild {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Medium",
    HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Stop-VSTeamBuild')]
   param(
      [parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
      [Alias('BuildID')]
      [Int] $Id,

      [switch] $Force,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName
   )

   process {
      if ($Force -or $pscmdlet.ShouldProcess($Id, "Stop-VSTeamBuild")) {
         try {
            $body = @{
               "status" = "Cancelling"
            }

            $bodyAsJson = $body | ConvertTo-Json -Compress -Depth 50

            # Call the REST API
            _callAPI -Method PATCH -ProjectName $ProjectName `
               -Area build `
               -Resource builds `
               -Id $Id `
               -body $bodyAsJson `
               -Version $(_getApiVersion Build) | Out-Null
         }

         catch {
            _handleException $_
         }
      }
   }
}