function Show-VSTeamBuild {
    [CmdletBinding(DefaultParameterSetName = 'ByID')]
    param (
        [Parameter(ParameterSetName = 'ByID', ValueFromPipelineByPropertyName = $true)]
        [Alias('BuildID')]
        [int[]] $Id,
        [Parameter(Mandatory=$true, Position = 0 )]
        [ValidateProject()]
        [ArgumentCompleter([ProjectCompleter])]
        $ProjectName
    )
    process {
                Show-Browser "$([VSTeamVersions]::Account)/$ProjectName/_build/index?buildId=$Id"
    }
}
