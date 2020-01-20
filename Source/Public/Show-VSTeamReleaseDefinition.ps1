function Show-VSTeamReleaseDefinition {
    [CmdletBinding()]
    param(
        [Parameter(ParameterSetName = 'ByID', ValueFromPipelineByPropertyName = $true)]
        [Alias('ReleaseDefinitionID')]
        [int] $Id,
        [Parameter(Mandatory=$true, Position = 0 )]
        [ValidateProject()]
        [ArgumentCompleter([ProjectCompleter])]
        $ProjectName
    )
    process {
        Write-Debug 'Show-VSTeamReleaseDefinition Process'
                # Build the url
        $url = "$([VSTeamVersions]::Account)/$ProjectName/_release"
        if ($id) {
            $url += "?definitionId=$id"
        }
        Show-Browser $url
    }
}
