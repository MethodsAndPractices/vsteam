function Get-VSTeamCloudSubscription {
    [CmdletBinding()]
    param()
    # Call the REST API
    $resp = _callAPI -Area 'distributedtask' -Resource 'serviceendpointproxy/azurermsubscriptions' `
        -Version $([VSTeamVersions]::DistributedTask)
    # Apply a Type Name so we can use custom format view and custom type extensions
    foreach ($item in $resp.value) {
        $item.PSObject.TypeNames.Insert(0, 'Team.AzureSubscription')
    }
    Write-Output $resp.value
}
