function Get-VSTeamGitRef {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true, Position=0)]
        [Alias('Id')]
        [guid] $RepositoryID,
        [Parameter(Mandatory=$true, Position = 1 )]
        [ValidateProject()]
        [ArgumentCompleter([ProjectCompleter])]
        $ProjectName
    )
    process {
        try {
            $resp = _callAPI -ProjectName $ProjectName -Id "$RepositoryID/refs" -Area git -Resource repositories -Version $([VSTeamVersions]::Git)
            $obj = @()
            foreach ($item in $resp.value) {
                $obj += [VSTeamRef]::new($item, $ProjectName)
            }
            Write-Output $obj
        }
        catch {
            throw $_
        }
    }
}
