function Get-VSTeamPolicyType {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [guid[]] $Id,
        [Parameter(Mandatory=$true, Position = 0 )]
        [ValidateProjectAttribute()]
        [ArgumentCompleter([ProjectCompleter])]
        $ProjectName
    )
    process {
                if ($id) {
            foreach ($item in $id) {
                try {
                    $resp = _callAPI -ProjectName $ProjectName -Id $item -Area policy -Resource types -Version $([VSTeamVersions]::Git)
                    $resp.PSObject.TypeNames.Insert(0, 'Team.PolicyType')
                    Write-Output $resp
                }
                catch {
                    throw $_
                }
            }
        }
        else {
            try {
                $resp = _callAPI -ProjectName $ProjectName -Area policy -Resource types -Version $([VSTeamVersions]::Git)
                # Apply a Type Name so we can use custom format view and custom type extensions
                foreach ($item in $resp.value) {
                    $item.PSObject.TypeNames.Insert(0, 'Team.PolicyType')
                }
                Write-Output $resp.value
            }
            catch {
                throw $_
            }
        }
    }
}
