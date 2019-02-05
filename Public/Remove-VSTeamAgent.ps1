function Remove-VSTeamAgent {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
   param(      
      [Parameter(Mandatory = $true, ValueFromPipeline = $true, Position = 0)]
      [int] $PoolId,

      [parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Position = 1)]
      [Alias('AgentID')]
      [int[]] $Id,

      # Forces the command without confirmation
      [switch] $Force
   )

   process {
      foreach ($item in $Id) {
         if ($force -or $pscmdlet.ShouldProcess($item,"Delete agent")) {
            try {
               _callAPI -Method Delete -Area "distributedtask/pools/$PoolId" -Resource agents -Id $item -Version $([VSTeamVersions]::DistributedTask) | Out-Null
               Write-Output "Deleted agent $item"
            }
            catch {
               _handleException $_
            }
         }
      }
   }
}