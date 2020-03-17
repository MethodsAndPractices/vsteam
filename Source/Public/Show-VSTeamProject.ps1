function Show-VSTeamProject {
    [CmdletBinding(DefaultParameterSetName = 'ByName')]
    param(
        [Parameter(ParameterSetName = 'ByID')]
        [Alias('ProjectID')]
        [string] $Id,
        [Parameter(ParameterSetName ='ByName', Position = 0 )]
        [ValidateProjectAttribute()]
        [ArgumentCompleter([ProjectCompleter] ) ]
        [Alias('ProjectName')]
        $Name
    )
    process {
        _hasAccount
        # Bind the parameter to a friendly variable
        $ProjectName = $PSBoundParameters["Name"]
        if ($id) {
            $ProjectName = $id
        }
        Show-Browser "$([VSTeamVersions]::Account)/$ProjectName"
    }
}
