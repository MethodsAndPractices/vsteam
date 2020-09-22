function Get-VSTeamJobRequest {
   [CmdletBinding(HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Get-VSTeamJobRequest')]
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

      $resp = _callAPI -Area "distributedtask/pools/$PoolId" `
         -Resource jobrequests `
         -QueryString $body `
         -Version $(_getApiVersion DistributedTaskReleased)

      $objs = @()

      foreach ($item in $resp.value) {
         $objs += [vsteam_lib.JobRequest]::new($item)
      }

      Write-Output $objs
   }
}