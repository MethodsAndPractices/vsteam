function Remove-VSTeamRelease {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High",
    HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Remove-VSTeamRelease')]
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
         if ($force -or $pscmdlet.ShouldProcess($item, "Delete Release")) {
            try {
               # Call the REST API
               _callAPI -Method DELETE -SubDomain vsrm -ProjectName $ProjectName `
                  -Area release `
                  -Resource releases `
                  -id $item `
                  -Version $(_getApiVersion Release) | Out-Null

               Write-Output "Deleted release $item"
            }
            catch {
               _handleException $_
            }
         }
      }
   }
}
