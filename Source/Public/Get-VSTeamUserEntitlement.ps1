function Get-VSTeamUserEntitlement {
    [CmdletBinding(DefaultParameterSetName = 'List')]
    param (
        [Parameter(ParameterSetName = 'List')]
        [int] $Top = 100,
        [Parameter(ParameterSetName = 'List')]
        [int] $Skip = 0,
        [Parameter(ParameterSetName = 'List')]
        [ValidateSet('Projects', 'Extensions', 'Grouprules')]
        [string[]] $Select,
        [Parameter(ParameterSetName = 'ByID')]
        [Alias('UserId')]
        [string[]] $Id
    )
    process {
        # Thi swill throw if this account does not support MemberEntitlementManagement
        _hasAccount
        if (-not [VSTeamVersions]::MemberEntitlementManagement) {
            throw 'This account does not support Member Entitlement.'
        }
        if ($Id) {
            foreach ($item in $Id) {
                    # Build the url to return the single build
                    # Call the REST API
                    $resp = _callAPI -SubDomain 'vsaex' -Version $([VSTeamVersions]::MemberEntitlementManagement) -Resource 'userentitlements' -id $item
                    $resp.PSObject.TypeNames.Insert(0, 'Team.UserEntitlement')
                    $resp.accessLevel.PSObject.TypeNames.Insert(0, 'Team.AccessLevel')
                    Write-Output $resp
            }
        }
        else {
            # Build the url to list the teams
            # $listurl = _buildUserURL
            $listurl = _buildRequestURI -SubDomain 'vsaex' -Resource 'userentitlements' `
                    -Version $([VSTeamVersions]::MemberEntitlementManagement)
            $listurl += _appendQueryString -name "top" -value $top -retainZero
            $listurl += _appendQueryString -name "skip" -value $skip -retainZero
            $listurl += _appendQueryString -name "select" -value ($select -join ",")
            # Call the REST API
            $resp = _callAPI -url $listurl
            # Apply a Type Name so we can use custom format view and custom type extensions
            foreach ($item in $resp.members) {
                $item.PSObject.TypeNames.Insert(0, 'Team.UserEntitlement')
                $item.accessLevel.PSObject.TypeNames.Insert(0, 'Team.AccessLevel')
            }
            Write-Output $resp.members
        }
    }
}
