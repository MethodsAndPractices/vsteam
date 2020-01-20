function Show-VSTeamApproval {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias('Id')]
        [int] $ReleaseDefinitionId,
        [Parameter(Mandatory=$true, Position = 0 )]
        [ValidateProject()]
        [ArgumentCompleter([ProjectCompleter])]
        $ProjectName
    )
    process {
        Write-Debug 'Show-VSTeamApproval Process'
                Show-Browser "$([VSTeamVersions]::Account)/$ProjectName/_release?releaseId=$ReleaseDefinitionId"
    }
}
