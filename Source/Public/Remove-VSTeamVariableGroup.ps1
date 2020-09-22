function Remove-VSTeamVariableGroup {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High",
    HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Remove-VSTeamVariableGroup')]
   param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string[]] $id,

      [switch] $Force,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName
   )

   process {
      foreach ($item in $id) {
         if ($Force -or $pscmdlet.ShouldProcess($item, "Delete Variable Group")) {
            # Call the REST API
            _callAPI -Method DELETE -ProjectName $projectName `
               -Area distributedtask `
               -Resource variablegroups `
               -Id $item `
               -Version $(_getApiVersion VariableGroups) | Out-Null

            Write-Output "Deleted variable group $item"
         }
      }
   }
}
