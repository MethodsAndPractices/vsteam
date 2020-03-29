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
            _callAPI -Method Patch -Area "distributedtask/pools/$PoolId" -NoProject -Resource agents -Id $item -Version $(_getApiVersion DistributedTask) -ContentType "application/json" -Body "{'enabled':false,'id':$item,'maxParallelism':1}" | Out-Null
            Write-Output "Disabled agent $item"
         }
         catch {
            _handleException $_
         }
      }
   }
}