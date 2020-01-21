function Get-VSTeamWorkItem {
    [CmdletBinding(DefaultParameterSetName = 'ByID')]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, Position = 0)]
        [int[]] $Id,
        [Parameter(ParameterSetName = 'List')]
        [ValidateSet('fail', 'omit')]
        [string] $ErrorPolicy = 'omit',
        [ValidateSet('None', 'Relations', 'Fields', 'Links', 'All')]
        [string] $Expand = 'None',
        [string[]] $Fields
    )
    Process {
        # Call the REST API
        if ($Id.Length -gt 1) {
            $resp = _callAPI -Area 'wit' -Resource 'workitems'  `
                -Version $([VSTeamVersions]::Core) `
                -Querystring @{
                '$Expand'    = $Expand
                fields        = ($Fields -join ',')
                errorPolicy = $ErrorPolicy
                ids            = ($Id -join ',')
            }
            foreach ($item in $resp.value) {
                $item.PSObject.TypeNames.Insert(0, 'Team.WorkItem')
            }
            return $resp.value
        }
        else {
            $a = $Id[0]
            $resp = _callAPI -Area 'wit' -Resource 'workitems'  `
                -Version $([VSTeamVersions]::Core) -id "$a" `
                -Querystring @{
                '$Expand' = $Expand
                fields    = ($Fields -join ',')
            }
            $resp.PSObject.TypeNames.Insert(0, 'Team.WorkItem')
            return $resp
        }
    }
}
