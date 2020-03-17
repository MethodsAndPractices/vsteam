function Get-VSTeamBuildArtifact {
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
        $resp = _callAPI -ProjectName $projectName -Area 'build' -Resource "builds/$Id/artifacts" `
            -Version $([VSTeamVersions]::Build)
        foreach ($item in $resp.value) {
            $item.PSObject.TypeNames.Insert(0, "Team.Build.Artifact")
            if ($item.PSObject.Properties.Match('resource').count -gt 0 -and $null -ne $item.resource) {
                $item.resource.PSObject.TypeNames.Insert(0, 'Team.Build.Artifact.Resource')
                if (Get-member -InputObject $item.resource -Name "properties") {
                  $item.resource.properties.PSObject.TypeNames.Insert(0, 'Team.Build.Artifact.Resource.Properties')
                }
            }
        }
        Write-Output $resp.value
    }
}
