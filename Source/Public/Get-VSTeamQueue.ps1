function Get-VSTeamQueue {
   [CmdletBinding(DefaultParameterSetName = 'List')]
   param(
      [Parameter(ParameterSetName = 'List')]
      [string] $queueName,

      [Parameter(ParameterSetName = 'List')]
      [ValidateSet('None', 'Manage', 'Use')]
      [string] $actionFilter,

      [Parameter(ParameterSetName = 'ByID')]
      [Alias('QueueID')]
      [string] $id,

      [Parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
      [ProjectValidateAttribute()]
      [ArgumentCompleter([ProjectCompleter])]
      [string] $ProjectName
   )
   
   process {
      if ($id) {
         $resp = _callAPI -ProjectName $ProjectName -Id $id -Area distributedtask -Resource queues `
            -Version $(_getApiVersion DistributedTask)

         $item = [VSTeamQueue]::new($resp, $ProjectName)

         Write-Output $item
      }
      else {
         $resp = _callAPI -ProjectName $projectName -Area distributedtask -Resource queues `
            -QueryString @{ queueName = $queueName; actionFilter = $actionFilter } -Version $(_getApiVersion DistributedTask)

         $objs = @()

         foreach ($item in $resp.value) {
            $objs += [VSTeamQueue]::new($item, $ProjectName)
         }
         
         Write-Output $objs
      }
   }
}
