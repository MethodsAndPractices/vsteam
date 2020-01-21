function Get-VSTeamOption {
    [CmdletBinding()]
    param([string] $subDomain)
    # Build the url to list the projects
    $params = @{"Method" = "Options"}
    if ($subDomain) {
        $params.Add("SubDomain", $subDomain)
    }
    # Call the REST API
    $resp = _callAPI @params
    # Apply a Type Name so we can use custom format view and custom type extensions
    foreach ($item in $resp.value) {
        $item.PSObject.TypeNames.Insert(0, 'Team.Option')
    }
    Write-Output $resp.value
}
