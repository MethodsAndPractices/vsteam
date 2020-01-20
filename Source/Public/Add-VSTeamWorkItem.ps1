function Add-VSTeamWorkItem {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Title,
        [Parameter(Mandatory = $false)]
        [string]$Description,
        [Parameter(Mandatory = $false)]
        [string]$IterationPath,
        [Parameter(Mandatory = $false)]
        [string]$AssignedTo,
        [Parameter(Mandatory = $false)]
        [int]$ParentId,
        [Parameter(Mandatory = $false)]
        [hashtable]$AdditionalFields,
        [Parameter( Position = 0 )]
        [ValidateProject()]
        [ArgumentCompleter([ProjectCompleter])]
        $ProjectName,
        [Parameter(Mandatory=$true)]
        [ArgumentCompleter([WorkItemTypeCompleter])]
        $WorkItemType
    )
    begin {
        $resp     = _callApi -ur ('{0}/{1}/_apis/wit/workitemtypes?api-version={2}' -f [VSTeamVersions]::Account , $ProjectName , [VSTeamVersions]::Core)
        $wiTypes  = ($resp.Replace('"":', '"_end":') | ConvertFrom-Json).value.name
        if ($WorkItemType -notin $wiTypes) {
            throw ("$workItemType is not a valid work item type. Valid types are " + ($wiTypes -join ', '))
        }
    }
    Process {
        # The type has to start with a $
        $WorkItemType = '$' + $WorkItemType
        # Constructing the contents to be send.
        # Empty parameters will be skipped when converting to json.
        [Array]$body = @(
            @{
                op    = "add"
                path  = "/fields/System.Title"
                value = $Title
            }
            @{
                op    = "add"
                path  = "/fields/System.Description"
                value = $Description
            }
            @{
                op    = "add"
                path  = "/fields/System.IterationPath"
                value = $IterationPath
            }
            @{
                op    = "add"
                path  = "/fields/System.AssignedTo"
                value = $AssignedTo
            }) | Where-Object { $_.value }
        if ($ParentId) {
            $parentUri = _buildRequestURI -ProjectName $ProjectName -Area 'wit' -Resource 'workitems' -id $ParentId
            $body += @{
                op    = "add"
                path  = "/relations/-"
                value = @{
                    "rel" = "System.LinkTypes.Hierarchy-Reverse"
                    "url" = $parentURI
                }
            }
        }
        #this loop must always come after the main work item fields defined in the
