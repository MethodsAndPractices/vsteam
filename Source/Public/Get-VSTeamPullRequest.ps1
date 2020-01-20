function Get-VSTeamPullRequest {
    [CmdletBinding()]
    param (
        [Alias('PullRequestId')]
        [string] $Id,
        [Parameter( Position = 0 )]
        [ValidateProject()]
        [ArgumentCompleter([ProjectCompleter])]
        $ProjectName
    )
    process {
                try {
            if ($ProjectName) {
                    $resp = _callAPI -ProjectName $ProjectName -Area git -Resource pullRequests -Version $([VSTeamVersions]::Git) -Id $Id
            }
            else {
                    $resp = _callAPI -Area git -Resource pullRequests -Version $([VSTeamVersions]::Git) -Id $Id
            }
            if ($resp.PSobject.Properties.Name -contains "value") {
                    $pullRequests = $resp.value
            }
            else {
                    $pullRequests = $resp
            }
            foreach ($respItem in $pullRequests) {
                    $respItem.PSObject.TypeNames.Insert(0, 'Team.PullRequest')
            }
            Write-Output $pullRequests
        }
        catch {
            _handleException $_
        }
    }
}
