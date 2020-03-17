function Get-VSTeamBuildTag {
    param(
        [parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias('BuildID')]
        [int] $Id,
        [Parameter(Mandatory=$true, Position = 0 )]
        [ValidateProjectAttribute()]
        [ArgumentCompleter([ProjectCompleter])]
        $ProjectName
    )
    process {
        # Call the REST API
        $resp = _callAPI -ProjectName $projectName -Area 'build' -Resource "builds/$Id/tags" `
            -Version $([VSTeamVersions]::Build)
        return $resp.value
    }
}
