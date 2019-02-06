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
            _callAPI -Method Patch -Area "distributedtask/pools/$PoolId" -Resource agents -Id $item -Version $([VSTeamVersions]::DistributedTask) -ContentType "application/json" -Body "{'enabled':false,'id':$item}" | Out-Null
            Write-Output "Disabled agent $item"
         }
         catch {
            _handleException $_
         }
      }
   }
}