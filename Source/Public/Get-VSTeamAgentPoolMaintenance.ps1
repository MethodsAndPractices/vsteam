function Get-VSTeamAgentPoolMaintenance {
   [CmdletBinding(
      HelpUri = 'https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Get-VSTeamAgentPoolMaintenance')]
   param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, Position = 1)]
      [Alias('PoolID')]
      [int] $Id
   )

   process {

      $resp = _callAPI -Method Get -NoProject -Area distributedtask -Resource pools -Id "$Id/maintenancedefinitions" -Version $(_getApiVersion DistributedTask)
      _applyTypesToAgentPoolMaintenance -item $resp

      Write-Output $resp.value
   }
}