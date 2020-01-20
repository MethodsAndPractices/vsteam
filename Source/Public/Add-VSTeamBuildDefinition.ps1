function Add-VSTeamBuildDefinition {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string] $InFile,
        [Parameter(Mandatory=$true, Position = 0 )]
        [ValidateProject()]
        [ArgumentCompleter([ProjectCompleter])]
        $ProjectName
    )
    process {
        
        $resp = _callAPI -Method Post -ProjectName $ProjectName -Area build -Resource definitions -Version $([VSTeamVersions]::Build) -infile $InFile -ContentType 'application/json'
        return $resp
    }
}
