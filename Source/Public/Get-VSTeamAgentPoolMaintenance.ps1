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

      if ($resp -and $resp.count -gt 0) {
         foreach ($schedule in $resp.value) {
            _applyTypesToAgentPoolMaintenance -item $schedule
         }
      }

      Write-Output $resp.value
   }
}