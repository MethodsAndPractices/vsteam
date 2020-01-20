function Add-VSTeam {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 1)]
        [Alias('TeamName')]
        [string]$Name,
        [string]$Description = '',
        [Parameter(Mandatory=$true, Position = 0)]
        [ValidateProject()]
        [ArgumentCompleter([ProjectCompleter])]
        $ProjectName
    )
    process {
        
        $body = '{ "name": "' + $Name + '", "description": "' + $Description + '" }'
        # Call the REST API
        $resp = _callAPI -Area 'projects' -Resource "$ProjectName/teams" `
            -Method Post -ContentType 'application/json' -Body $body -Version $([VSTeamVersions]::Core)
        $team = [VSTeamTeam]::new($resp, $ProjectName)
        Write-Output $team
    }
}
