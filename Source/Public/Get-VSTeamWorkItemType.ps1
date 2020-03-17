function Get-VSTeamWorkItemType {
    [CmdletBinding(DefaultParameterSetName = 'List')]
    param(
        [Parameter(Mandatory=$true, Position = 0 )]
        [ValidateProjectAttribute()]
        [ArgumentCompleter([ProjectCompleter])]
        $ProjectName,
        [ArgumentCompleter([WorkItemTypeCompleter])]
        $WorkItemType
    )

    Process {
    # Call the REST API
        if ($WorkItemType) {
            $resp = _callAPI -ProjectName $ProjectName -Area 'wit' -Resource 'workitemtypes'  `
                -Version $([VSTeamVersions]::Core) -id $WorkItemType
            # This call returns JSON with "": which causes the ConvertFrom-Json to fail.
            # To replace all the "": with "_end":
            $resp = $resp.Replace('"":', '"_end":') | ConvertFrom-Json
            $resp.PSObject.TypeNames.Insert(0, 'Team.WorkItemType')
            return $resp
        }
        else {
            $resp = _callAPI -ProjectName $ProjectName -Area 'wit' -Resource 'workitemtypes'  `
                -Version $([VSTeamVersions]::Core)
            # This call returns JSON with "": which causes the ConvertFrom-Json to fail.
            # To replace all the "": with "_end":
            $resp = $resp.Replace('"":', '"_end":') | ConvertFrom-Json
            # Apply a Type Name so we can use custom format view and custom type extensions
            foreach ($item in $resp.value) {
                $item.PSObject.TypeNames.Insert(0, 'Team.WorkItemType')
            }
            return $resp.value
        }
    }
}
