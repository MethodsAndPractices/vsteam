Set-StrictMode -Version Latest

# Load common code
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$here\common.ps1"

function _buildURL {
    param(
        [parameter(Mandatory = $true)]
        [string] $ProjectName,
        [string] $TeamId
    )

    if(-not $env:TEAM_ACCT) {
        throw 'You must call Add-TeamAccount before calling any other functions in this module.'
    }

    $version = '1.0'
    $resource = "/projects/$ProjectName/teams"
    $instance = $env:TEAM_ACCT

    if ($TeamId) {
        $resource += "/$TeamId"
    }

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
       $ProjectName
    )

    # Add the ProjectName as a NoteProperty so we can use it further down the pipeline (it's not returned from the REST call)
    $item | Add-Member -MemberType NoteProperty -Name ProjectName -Value $ProjectName
    $item.PSObject.TypeNames.Insert(0, 'Team.Team')
}

function Get-Team {
    [CmdletBinding(DefaultParameterSetName = 'List')]
    param (
       [Parameter(ParameterSetName = 'List')]
       [int] $Top,
 
       [Parameter(ParameterSetName = 'List')]
       [int] $Skip,
 
       [Parameter(ParameterSetName = 'ByID')]
       [string[]] $TeamId
    )

    DynamicParam {
        _buildProjectNameDynamicParam
     }

     process {
        # Bind the parameter to a friendly variable
        $ProjectName = $PSBoundParameters["ProjectName"]

        if($TeamId) {
            foreach ($item in $TeamId) {
                # Build the url to return the single build
                $listurl = _buildURL -projectName $ProjectName -teamId $item

                # Call the REST API
                if (_useWindowsAuthenticationOnPremise) {
                   $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Uri $listurl -UseDefaultCredentials
                }
                else {
                   $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Uri $listurl -Headers @{Authorization = "Basic $env:TEAM_PAT"}
                }

                _applyTypes -item $resp -ProjectName $ProjectName

                Write-Output $resp
            }
        } else {
            # Build the url to list the teams
            $listurl = _buildURL -projectName $ProjectName
            
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
                _applyTypes -item $item -ProjectName $ProjectName
            }

            Write-Output $resp.value
        }
    } 
}

function Add-Team {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$TeamName,
        [string]$Description = ""
    )
    DynamicParam {
        _buildProjectNameDynamicParam
    }

    process { 
        # Bind the parameter to a friendly variable
        $ProjectName = $PSBoundParameters["ProjectName"]

        $listurl = _buildURL -ProjectName $ProjectName
        $body = '{ "name": "' + $TeamName + '", "description": "' + $Description + '" }'

        # Call the REST API
        if (_useWindowsAuthenticationOnPremise) {
            $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Method Post -ContentType "application/json" -Body $body -Uri $listurl -UseDefaultCredentials
        }
        else {
            $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Method Post -ContentType "application/json" -Body $body -Uri $listurl -Headers @{Authorization = "Basic $env:TEAM_PAT"}
        }

        _applyTypes -item $resp -ProjectName $ProjectName

        return $resp
    }
}

function Update-Team {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $True, ValueFromPipelineByPropertyName = $true)]
        [Alias('name')]
        [string]$TeamToUpdate,
        [string]$NewTeamName,
        [string]$Description
    )
    DynamicParam {
        _buildProjectNameDynamicParam
    }

    process { 
        # Bind the parameter to a friendly variable
        $ProjectName = $PSBoundParameters["ProjectName"]

        $listurl = _buildURL -ProjectName $ProjectName -TeamId $TeamToUpdate
        if(-not $NewTeamName -and -not $Description) {
            throw 'You must provide a new team name or description, or both.'
        }

        if(-not $NewTeamName)
        { 
            $body = '{"description": "' + $Description + '" }'
        }
        if(-not $Description)
        {
            $body = '{ "name": "' + $NewTeamName + '" }'
        }
        if($NewTeamName -and $Description)
        {
            $body = '{ "name": "' + $NewTeamName + '", "description": "' + $Description + '" }'            
        }

        # Call the REST API
        if (_useWindowsAuthenticationOnPremise) {
            $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Method Patch -ContentType "application/json" -Body $body -Uri $listurl -UseDefaultCredentials
        }
        else {
            $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Method Patch -ContentType "application/json" -Body $body -Uri $listurl -Headers @{Authorization = "Basic $env:TEAM_PAT"}
        }

        _applyTypes -item $resp -ProjectName $ProjectName

        return $resp
    }
}

function Remove-Team {
    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact="High")]
    param(
        [Parameter(Mandatory = $True, ValueFromPipelineByPropertyName = $true)]
        [Alias('name')]
        [string]$TeamId,

        [switch]$Force
    )
    DynamicParam {
        _buildProjectNameDynamicParam
    }

    process { 
        # Bind the parameter to a friendly variable
        $ProjectName = $PSBoundParameters["ProjectName"]

        $listurl = _buildURL -ProjectName $ProjectName -TeamId $TeamId

        if ($Force -or $PSCmdlet.ShouldProcess($TeamId, "Delete team")) {
            # Call the REST API
            if (_useWindowsAuthenticationOnPremise) {
                $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Method Delete -Uri $listurl -UseDefaultCredentials
            }
            else {
                $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Method Delete -Uri $listurl -Headers @{Authorization = "Basic $env:TEAM_PAT"}
            }

            Write-Output "Deleted team $TeamId"
        }
    }
}

Export-ModuleMember -Alias * -Function Get-Team, Add-Team, Update-Team, Remove-Team