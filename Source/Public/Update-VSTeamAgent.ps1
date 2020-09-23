function Update-VSTeamAgent {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High",
    HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Update-VSTeamAgent')]
   param(
      [Parameter(Mandatory = $true, ValueFromPipeline = $true, Position = 0)]
      [int] $PoolId,

      [parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Position = 1)]
      [Alias('AgentID')]
      [int[]] $Id,

      [switch] $Force
   )

   process {
      foreach ($item in $Id) {
         try {
            if ($Force -or $pscmdlet.ShouldProcess($item, "Update-VSTeamAgent")) {
               _callAPI -Method POST `
                  -Area "distributedtask/pools/$PoolId" `
                  -Resource messages `
                  -QueryString @{agentId = $item } `
                  -Version $(_getApiVersion DistributedTaskReleased) | Out-Null

               Write-Output "Update agent $item"
            }
         }
         catch {
            _handleException $_
         }
      }
   }
}