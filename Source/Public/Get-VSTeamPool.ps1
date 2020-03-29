function Get-VSTeamPool {
   [CmdletBinding(DefaultParameterSetName = 'List')]
   param(
      [Parameter(ParameterSetName = 'ByID', Mandatory = $true, ValueFromPipelineByPropertyName = $true, Position = 1)]
      [Alias('PoolID')]
      [int] $Id
   )

   process {

      if ($id) {
         $resp = _callAPI -NoProject -Area distributedtask -Resource pools -Id $id -Version $(_getApiVersion DistributedTask)

         # Storing the object before you return it cleaned up the pipeline.
         # When I just write the object from the constructor each property
         # seemed to be written
         $item = [VSTeamPool]::new($resp)

         Write-Output $item
      }
      else {
         $resp = _callAPI -NoProject -Area distributedtask -Resource pools -Version $(_getApiVersion DistributedTask)

         $objs = @()

         foreach ($item in $resp.value) {
            $objs += [VSTeamPool]::new($item)
         }

         Write-Output $objs
      }
   }
}