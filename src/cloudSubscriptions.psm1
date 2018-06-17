Set-StrictMode -Version Latest

# Load common code
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$here\common.ps1"

# Apply types to the returned objects so format and type files can
# identify the object and act on it.
function _applyTypesToAzureSubscription {
   param($item)

   $item.PSObject.TypeNames.Insert(0, 'Team.AzureSubscription')
}

function Get-VSTeamCloudSubscription {
   [CmdletBinding()]
   param()

   # Call the REST API
   $resp = _callAPI -Area 'distributedtask' -Resource 'serviceendpointproxy/azurermsubscriptions' `
      -Version $VSTeamVersionTable.DistributedTask

   # Apply a Type Name so we can use custom format view and custom type extensions
   foreach ($item in $resp.value) {
      _applyTypesToAzureSubscription -item $item
   }

   Write-Output $resp.value
}

Set-Alias Get-CloudSubscription Get-VSTeamCloudSubscription

Export-ModuleMember `
   -Function Get-VSTeamCloudSubscription `
   -Alias Get-CloudSubscription