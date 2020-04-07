function Get-VSTeamCloudSubscription {
   [CmdletBinding()]
   param()

   # Call the REST API
   $resp = _callAPI -Area 'distributedtask' -Resource 'serviceendpointproxy/azurermsubscriptions' `
      -Version $(_getApiVersion DistributedTask) -NoProject

   # Apply a Type Name so we can use custom format view and custom type extensions
   foreach ($item in $resp.value) {
      _applyTypesToAzureSubscription -item $item
   }

   Write-Output $resp.value
}
