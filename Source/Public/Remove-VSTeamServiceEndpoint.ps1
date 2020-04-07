function Remove-VSTeamServiceEndpoint {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
   param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string[]] $id,
      [switch] $Force,
      [Parameter(Mandatory=$true, Position = 0 )]
      [ValidateProjectAttribute()]
      [ArgumentCompleter([ProjectCompleter])]
      $ProjectName
   )
   process {
      foreach ($item in $id) {
         if ($Force -or $pscmdlet.ShouldProcess($item, "Delete Service Endpoint")) {
            # Call the REST API
            _callAPI -projectName $projectName -Area 'distributedtask' -Resource 'serviceendpoints' -Id $item  `
               -Method Delete -Version $(_getApiVersion DistributedTask) | Out-Null

               Write-Output "Deleted service endpoint $item"
         }
      }
   }
}
