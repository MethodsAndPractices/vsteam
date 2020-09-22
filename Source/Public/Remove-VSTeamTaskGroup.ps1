function Remove-VSTeamTaskGroup {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Low",
    HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Remove-VSTeamTaskGroup')]
   param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string[]] $Id,

      [switch] $Force,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName
   )
   process {
      foreach ($item in $Id) {
         if ($Force -or $pscmdlet.ShouldProcess($item, "Delete Task Group")) {
            # Call the REST API
            _callAPI -Method DELETE -ProjectName $ProjectName `
               -Area distributedtask `
               -Resource taskgroups `
               -Id $item `
               -Version $(_getApiVersion TaskGroups) | Out-Null

            Write-Output "Deleted task group $item"
         }
      }
   }
}
