function Get-VSTeamCloudSubscription {
   [CmdletBinding(HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Get-VSTeamCloudSubscription')]
   param()

   # Call the REST API
   $resp = _callAPI -NoProject `
      -Area distributedtask `
      -Resource 'serviceendpointproxy/azurermsubscriptions' `
      -Version $(_getApiVersion DistributedTask)

   # Apply a Type Name so we can use custom format view and custom type extensions
   foreach ($item in $resp.value) {
      _applyTypesToAzureSubscription -item $item
   }

   Write-Output $resp.value
}
