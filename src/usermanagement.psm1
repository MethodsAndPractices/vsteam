Set-StrictMode -Version Latest

# Load common code
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$here\common.ps1"

function _buildURL {
    param(
    )

    if(-not $env:TEAM_ACCT) {
        throw 'You must call Add-TeamAccount before calling any other functions in this module.'
    }

    $resource = "/apiusermanagement/GetAccountUsers"
    $instance = $env:TEAM_ACCT
    $vsspsInstance = $instance -replace '.visualstudio.com', '.vssps.visualstudio.com'

    # Build the url to list the projects
    return $vsspsInstance + $resource
}

function _isVSTS {
    $instance = $env:TEAM_ACCT
    return $instance.EndsWith(".visualstudio.com") 
}

# Apply types to the returned objects so format and type files can
# identify the object and act on it.
function _applyTypes {
   param(
       [Parameter(Mandatory = $true)]
       $item
    )

    $item.PSObject.TypeNames.Insert(0, 'Team.UserAccount')
}

function Get-VSTeamAccountUser {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [string]$uniqueName
    )

    process {
        if(_isVSTS)
        {
            # Build the url to return the single build
            $listurl = _buildURL

            # Call the REST API
            if (_useWindowsAuthenticationOnPremise) {
                $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Uri $listurl -UseDefaultCredentials
            }
            else {
                $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Uri $listurl -Headers @{Authorization = "Basic $env:TEAM_PAT"}
            }

            $users = $resp.Users

            if($uniqueName -ne "")
            {
                $user = $users | Where-Object { $_.SignInAddress -eq $uniqueName }
                if($user) {
                    _applyTypes -item $user
                    Write-Output $user
                }
            } else {
                foreach($user in $users)
                {
                    _applyTypes -item $user        
                }
                Write-Output $users
            }
        } else {
            Write-Output "This call is not supported on your account."
        }
    } 
}

Set-Alias Get-VSAccountUser Get-VSTeamAccountUser

Export-ModuleMember `
    -Function Get-VSTeamAccountUser `
    -Alias Get-VSAccountUser