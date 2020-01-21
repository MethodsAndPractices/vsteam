function Get-VSTeamResourceArea {
    [CmdletBinding()]
    param()
    # Call the REST API
    $resp = _callAPI -Resource 'resourceareas'
    # Apply a Type Name so we can use custom format view and custom type extensions
    foreach ($item in $resp.value) {
        $item.PSObject.TypeNames.Insert(0, 'Team.ResourceArea')
    }
    Write-Output $resp.value
}
