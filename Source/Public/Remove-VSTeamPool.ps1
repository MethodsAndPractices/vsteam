function Remove-VSTeamPool {
   [CmdletBinding()]
   param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, Position = 1)]
      [Alias('PoolID')]
      [int] $Id
   )

   process {

      $null = _callAPI -Method Delete -NoProject -Area distributedtask -Resource pools -Id $id -Version $(_getApiVersion DistributedTask)

   }
}