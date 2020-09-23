function Enable-VSTeamAgent {
   [CmdletBinding(HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Enable-VSTeamAgent')]
   param(
      [Parameter(Mandatory = $true, ValueFromPipeline = $true, Position = 0)]
      [int] $PoolId,

      [parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Position = 1)]
      [Alias('AgentID')]
      [int[]] $Id
   )

   process {
      foreach ($item in $Id) {
         try {
            _callAPI -Method PATCH -NoProject `
               -Area "distributedtask/pools/$PoolId" `
               -Resource agents `
               -Id $item `
               -Body "{'enabled':true,'id':$item,'maxParallelism':1}" `
               -Version $(_getApiVersion DistributedTask) | Out-Null

            Write-Output "Enabled agent $item"
         }
         catch {
            _handleException $_
         }
      }
   }
}