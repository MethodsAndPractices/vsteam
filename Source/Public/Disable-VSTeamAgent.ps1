function Disable-VSTeamAgent {
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
               -Body "{'enabled':false,'id':$item,'maxParallelism':1}" `
               -Version $(_getApiVersion DistributedTaskReleased) | Out-Null

            Write-Output "Disabled agent $item"
         }
         catch {
            _handleException $_
         }
      }
   }
}