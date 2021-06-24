function Remove-VSTeamPool {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Medium",
      HelpUri = 'https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Remove-VSTeamPool')]
   [CmdletBinding()]
   param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, Position = 1)]
      [Alias('PoolID')]
      [int] $Id
   )

   process {
      if ($force -or $pscmdlet.ShouldProcess($Id, "Remove Pool")) {
         $null = _callAPI -Method Delete -NoProject -Area distributedtask -Resource pools -Id $id -Version $(_getApiVersion DistributedTask)
      }
   }
}