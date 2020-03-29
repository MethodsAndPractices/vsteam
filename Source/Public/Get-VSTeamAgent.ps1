function Get-VSTeamAgent {
   [CmdletBinding(DefaultParameterSetName = 'List')]
   param(
      [Parameter(Mandatory = $true, ValueFromPipeline = $true, Position = 0)]
      [int] $PoolId,

      [Parameter(ParameterSetName = 'ByID', Mandatory = $true, ValueFromPipelineByPropertyName = $true, Position = 1)]
      [Alias('AgentID')]
      [int] $Id
   )

   process {

      if ($id) {
         $resp = _callAPI -Area "distributedtask/pools/$PoolId" -Resource agents -Id $id -NoProject `
            -Body @{includeCapabilities = 'true'} -Version $(_getApiVersion DistributedTask)

         # Storing the object before you return it cleaned up the pipeline.
         # When I just write the object from the constructor each property
         # seemed to be written
         $item = [VSTeamAgent]::new($resp, $PoolId)

         Write-Output $item
      }
      else {
         $resp = _callAPI -Area "distributedtask/pools/$PoolId" -Resource agents -NoProject `
            -Body @{includeCapabilities = 'true'} -Version $(_getApiVersion DistributedTask)

         $objs = @()

         foreach ($item in $resp.value) {
            $objs += [VSTeamAgent]::new($item, $PoolId)
         }

         Write-Output $objs
      }
   }
}