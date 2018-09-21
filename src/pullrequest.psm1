Set-StrictMode -Version Latest

# Load common code
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$here\common.ps1"

# Apply types to the returned objects so format and type files can
# identify the object and act on it.
function _applyTypes {
    param($item)

    $item.PSObject.TypeNames.Insert(0, 'Team.PullRequest')
}

function Get-VSTeamPullRequest {
    [CmdletBinding()]
    param (
        [Alias('PullRequestId')]
        [string] $Id
    )

    DynamicParam {
        _buildProjectNameDynamicParam -mandatory $false
    }

    Process {
        # Bind the parameter to a friendly variable
        $ProjectName = $PSBoundParameters["ProjectName"]

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
                _applyTypes -item $respItem
            }

            Write-Output $pullRequests
        }
        catch {
            _handleException $_
        }
    }
}

function Show-VSTeamPullRequest {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Position = 0)]
        [Alias('PullRequestId')]
        [int] $Id
    )

    process {
        $pullRequest = Get-PullRequest -PullRequestId $Id

        $projectName = $pullRequest.repository.project.name
        $repositoryId = $pullRequest.repositoryName

        Show-Browser "$([VSTeamVersions]::Account)/$projectName/_git/$repositoryId/pullrequest/$Id"
    }
}

Set-Alias Get-PullRequest Get-VSTeamPullRequest
Set-Alias Show-PullRequest Show-VSTeamPullRequest

Export-ModuleMember `
    -Function Get-VSTeamPullRequest, Show-VSTeamPullRequest `
    -Alias Get-PullRequest, Show-PullRequest