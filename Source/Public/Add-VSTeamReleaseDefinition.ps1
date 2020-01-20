function Add-VSTeamReleaseDefinition {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string] $inFile,
        [Parameter(Mandatory=$true, Position = 0 )]
        [ValidateProject()]
        [ArgumentCompleter([ProjectCompleter])]
        $ProjectName
    )
    process {
        Write-Debug 'Add-VSTeamReleaseDefinition Process'
        
        $resp = _callAPI -Method Post -subDomain vsrm -Area release -Resource definitions -ProjectName $ProjectName `
            -Version $([VSTeamVersions]::Release) -inFile $inFile -ContentType 'application/json'
        Write-Output $resp
    }
}
