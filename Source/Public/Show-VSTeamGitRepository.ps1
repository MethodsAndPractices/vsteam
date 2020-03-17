function Show-VSTeamGitRepository {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [string] $RemoteUrl,
        [Parameter( Position = 0 )]
        [ValidateProjectAttribute()]
        [ArgumentCompleter([ProjectCompleter])]
        $ProjectName
    )
    process {
                if ($RemoteUrl) {
            Show-Browser $RemoteUrl
        }
        else {
            Show-Browser "$([VSTeamVersions]::Account)/_git/$ProjectName"
        }
    }
}
