Set-StrictMode -Version Latest

# Load common code
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$here\common.ps1"

function _buildURL {
   if (-not $env:TEAM_ACCT) {
      throw 'You must call Add-TeamAccount before calling any other functions in this module.'
   }

   $resource = "/apiusermanagement/GetAccountUsers"
   $instance = $env:TEAM_ACCT
   $vsspsInstance = $instance -replace '.visualstudio.com', '.vssps.visualstudio.com'

   # Build the url to list the projects
   return $vsspsInstance + $resource
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
      [Parameter(ValueFromPipelineByPropertyName = $true)]
      [string]$uniqueName
   )

   process {
      if (_isVSTS $env:TEAM_ACCT) {
         # Build the url to return the single build
         $listurl = _buildURL

         # Call the REST API
         $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Uri $listurl -Headers @{Authorization = "Basic $env:TEAM_PAT"}

         $users = $resp.Users

         if ($uniqueName -ne "") {
            $user = $users | Where-Object { $_.SignInAddress -eq $uniqueName }
            if ($user) {
               _applyTypes -item $user
               Write-Output $user
            }
         }
         else {
            foreach ($user in $users) {
               _applyTypes -item $user        
            }
            Write-Output $users
         }
      }
      else {
         Write-Error "This call is not currently implemented on TFS."
      }
   } 
}

Set-Alias Get-VSAccountUser Get-VSTeamAccountUser

Export-ModuleMember `
   -Function Get-VSTeamAccountUser `
   -Alias Get-VSAccountUser