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

    if(-not $env:TEAM_ACCT) {
        throw 'You must call Add-TeamAccount before calling any other functions in this module.'
    }

    $version = '1.0'
    $resource = "/projects/$ProjectName/teams/$TeamId/members"
    $instance = $env:TEAM_ACCT

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

function Get-TeamMember {
    [CmdletBinding()]
    param (
       [Parameter()]
       [int] $Top,
 
       [Parameter()]
       [int] $Skip,
 
       [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName=$true)]
       [Alias('Name')]
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
        if (_useWindowsAuthenticationOnPremise) {
            $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Uri $listurl -UseDefaultCredentials
        }
        else {
            $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Uri $listurl -Headers @{Authorization = "Basic $env:TEAM_PAT"}
        }

        # Apply a Type Name so we can use custom format view and custom type extensions
        foreach ($item in $resp.value) {
            _applyTypes -item $item -team $TeamId -ProjectName $ProjectName
        }

        Write-Output $resp.value
    } 
}

Export-ModuleMember -Alias * -Function Get-TeamMember