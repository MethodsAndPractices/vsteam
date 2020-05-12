function Remove-VSTeamVariableGroup {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
   param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string[]] $id,

      [switch] $Force,

      [Parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
      [ProjectValidateAttribute()]
      [ArgumentCompleter([ProjectCompleter])]
      [string] $ProjectName
   )

   process {
      foreach ($item in $id) {
         if ($Force -or $pscmdlet.ShouldProcess($item, "Delete Variable Group")) {
            # Call the REST API
            _callAPI -projectName $projectName -Area 'distributedtask' -Resource 'variablegroups' -Id $item  `
               -Method Delete -Version $(_getApiVersion VariableGroups) | Out-Null

            Write-Output "Deleted variable group $item"
         }
      }
   }
}
