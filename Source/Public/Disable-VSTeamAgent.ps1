# Disables an agent in a pool.
#
# Get-VSTeamOption 'distributedtask' 'agents'
# id              : e298ef32-5878-4cab-993c-043836571f42
# area            : distributedtask
# resourceName    : agents
# routeTemplate   : _apis/{area}/pools/{poolId}/{resource}/{agentId}
# http://bit.ly/Disable-VSTeamAgent

function Disable-VSTeamAgent {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High",
    HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Disable-VSTeamAgent')]
   param(
      [Parameter(Mandatory = $true, ValueFromPipeline = $true, Position = 0)]
      [int] $PoolId,

      [parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Position = 1)]
      [Alias('AgentID')]
      [int[]] $Id,

      [switch] $Force
   )

   process {
      if ($Force -or $pscmdlet.ShouldProcess("Agent $Id", "Disable Agent")) {
         foreach ($item in $Id) {
            try {
               _callAPI -Method PATCH -NoProject `
                  -Area "distributedtask/pools/$PoolId" `
                  -Resource "agents" `
                  -Id $item `
                  -Body "{'enabled':false,'id':$item,'maxParallelism':1}" `
                  -Version $(_getApiVersion DistributedTask) | Out-Null

               Write-Output "Disabled agent $item"
            }
            catch {
               _handleException $_
            }
         }
      }
   }
}