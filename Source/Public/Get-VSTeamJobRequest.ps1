function Get-VSTeamJobRequest {
   [CmdletBinding()]
   param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, Position = 0)]
      [int] $PoolId,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ValueFromPipeline = $true, Position = 1)]
      [Alias('ID')]
      [int] $AgentID,
      
      [int] $completedRequestCount
   )

   process {

      if ($null -ne $completedRequestCount) {
         $body = @{
            agentid               = $AgentID
            completedRequestCount = $completedRequestCount
         }
      }
      else {
         $body = @{agentid = $AgentID }
      }      

      $resp = _callAPI -Area "distributedtask/pools/$PoolId" -Resource "jobrequests" `
         -QueryString $body -Version $(_getApiVersion DistributedTask)

      $objs = @()

      foreach ($item in $resp.value) {
         $objs += [VSTeamJobRequest]::new($item)
      }

      Write-Output $objs
   }
}