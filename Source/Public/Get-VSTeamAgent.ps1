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
         $resp = _callAPI -Area "distributedtask/pools/$PoolId" -Resource agents -Id $id `
            -Body @{includeCapabilities = 'true'} -Version $([VSTeamVersions]::DistributedTask)

         # Storing the object before you return it cleaned up the pipeline.
         # When I just write the object from the constructor each property
         # seemed to be written
         $item = [VSTeamAgent]::new($resp)

         Write-Output $item
      }
      else {
         $resp = _callAPI -Area "distributedtask/pools/$PoolId" -Resource agents `
            -Body @{includeCapabilities = 'true'} -Version $([VSTeamVersions]::DistributedTask)

         $objs = @()

         foreach ($item in $resp.value) {
            $objs += [VSTeamAgent]::new($item)
         }

         Write-Output $objs
      }
   }
}