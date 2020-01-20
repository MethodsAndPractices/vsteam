function Remove-VSTeamRelease {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
    param(
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [int[]] $Id,
        # Forces the command without confirmation
        [switch] $Force,
        [Parameter(Mandatory=$true, Position = 0 )]
        [ValidateProject()]
        [ArgumentCompleter([ProjectCompleter])]
        $ProjectName
    )
    process {
        Write-Debug 'Remove-VSTeamRelease Process'
                foreach ($item in $id) {
            if ($force -or $pscmdlet.ShouldProcess($item, "Delete Release")) {
                Write-Debug 'Remove-VSTeamRelease Call the REST API'
                try {
                    # Call the REST API
                    _callAPI -Method Delete -SubDomain vsrm -Area release -Resource releases -ProjectName $ProjectName -id $item -Version $([VSTeamVersions]::Release) | Out-Null
                    Write-Output "Deleted release $item"
                }
                catch {
                    _handleException $_
                }
            }
        }
    }
}
