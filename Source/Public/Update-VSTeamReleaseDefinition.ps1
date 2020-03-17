function Update-VSTeamReleaseDefinition {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Medium", DefaultParameterSetName = 'JSON')]
    Param(
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'File')]
        [string] $InFile,
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'JSON')]
        [string] $ReleaseDefinition,
        # Forces the command without confirmation
        [switch] $Force,
        [Parameter(Mandatory=$true, Position = 0 )]
        [ValidateProjectAttribute()]
        [ArgumentCompleter([ProjectCompleter])]
        $ProjectName
    )
    process {
                if ($Force -or $pscmdlet.ShouldProcess('', "Update Release Definition")) {
            # Call the REST API
            if ($InFile) {
                _callAPI -Method Put -ProjectName $ProjectName -SubDomain vsrm -Area Release -Resource definitions -Version $([VSTeamVersions]::Release) -InFile $InFile -ContentType 'application/json' | Out-Null
            }
            else {
                _callAPI -Method Put -ProjectName $ProjectName -SubDomain vsrm -Area Release -Resource definitions -Version $([VSTeamVersions]::Release) -Body $ReleaseDefinition -ContentType 'application/json' | Out-Null
            }
        }
    }
}
