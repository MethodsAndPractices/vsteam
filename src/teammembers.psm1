Set-StrictMode -Version Latest

# Load common code
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$here\common.ps1"

function _buildURL {
    param(
        [parameter(Mandatory = $true)]
        [string] $ProjectName,
        [parameter(Mandatory = $true)]
        [string] $TeamId
    )

    _hasAccount

    $instance = $VSTeamVersionTable.Account
    $version = $VSTeamVersionTable.Core
    $resource = "/projects/$ProjectName/teams/$TeamId/members"

    # Build the url to list the projects
    return $instance + '/_apis' + $resource + '?api-version=' + $version
}

# Apply types to the returned objects so format and type files can
# identify the object and act on it.
function _applyTypes {
    param(
        [Parameter(Mandatory = $true)]
        $item,
        [Parameter(Mandatory = $true)]
        $team,
        [Parameter(Mandatory = $true)]
        $ProjectName
    )
    
    # Add the team name as a NoteProperty so we can use it further down the pipeline (it's not returned from the REST call)
    $item | Add-Member -MemberType NoteProperty -Name Team -Value $team
    $item | Add-Member -MemberType NoteProperty -Name ProjectName -Value $ProjectName
    $item.PSObject.TypeNames.Insert(0, 'Team.TeamMember')
}

function Get-VSTeamMember {
    [CmdletBinding()]
    param (
       [Parameter()]
       [int] $Top,
 
       [Parameter()]
       [int] $Skip,
 
       [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName=$true)]
       [Alias('Name')]
       [Alias('Id')]
       [string] $TeamId
    )

    DynamicParam {
        _buildProjectNameDynamicParam
     }

     process {
        # Bind the parameter to a friendly variable
        $ProjectName = $PSBoundParameters["ProjectName"]


        # Build the url to list the builds
        $listurl = _buildURL -projectName $ProjectName -teamId $TeamId
        
        $listurl += _appendQueryString -name "`$top" -value $top
        $listurl += _appendQueryString -name "`$skip" -value $skip

        # Call the REST API
        $resp = _get -url $listurl

        # Apply a Type Name so we can use custom format view and custom type extensions
        foreach ($item in $resp.value) {
            _applyTypes -item $item -team $TeamId -ProjectName $ProjectName
        }

        Write-Output $resp.value
    } 
}

Set-Alias Get-TeamMember Get-VSTeamMember

Export-ModuleMember `
 -Function Get-VSTeamMember `
 -Alias Get-TeamMember