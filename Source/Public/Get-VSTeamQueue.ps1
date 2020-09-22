function Get-VSTeamQueue {
   [CmdletBinding(DefaultParameterSetName = 'List',
    HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Get-VSTeamQueue')]
   param(
      [Parameter(ParameterSetName = 'List')]
      [string] $queueName,

      [Parameter(ParameterSetName = 'List')]
      [ValidateSet('None', 'Manage', 'Use')]
      [string] $actionFilter,

      [Parameter(ParameterSetName = 'ByID')]
      [Alias('QueueID')]
      [string] $id,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName
   )

   process {
      $commonArgs = @{
         ProjectName = $projectName
         Area        = 'distributedtask'
         Resource    = 'queues'
         Version     = $(_getApiVersion DistributedTask)
      }

      if ($id) {
         $resp = _callAPI @commonArgs -Id $id

         $item = [vsteam_lib.Queue]::new($resp, $ProjectName)

         Write-Output $item
      }
      else {
         $resp = _callAPI @commonArgs -QueryString @{ queueName = $queueName; actionFilter = $actionFilter }

         $objs = @()

         foreach ($item in $resp.value) {
            $objs += [vsteam_lib.Queue]::new($item, $ProjectName)
         }

         Write-Output $objs
      }
   }
}
