Set-StrictMode -Version Latest

# Load common code
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$here\common.ps1"

function _buildURL {
   if(-not $env:TEAM_ACCT) {
      throw 'You must call Add-VSTeamAccount before calling any other functions in this module.'
   }

   $resource = "/distributedtask/serviceendpointproxy/azurermsubscriptions"
   $instance = $env:TEAM_ACCT

   # Build the url to list the projects
   return $instance + '/_apis' + $resource
}

# Apply types to the returned objects so format and type files can
# identify the object and act on it.
function _applyTypes {
   param($item)

   $item.PSObject.TypeNames.Insert(0, 'Team.AzureSubscription')
}

function Get-CloudSubscription {
   [CmdletBinding()]
   param()

   # Build the url
   $url = _buildURL

   # Call the REST API
   if (_useWindowsAuthenticationOnPremise) {
     $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Uri $url -UseDefaultCredentials
    } else {
     $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Uri $url -Headers @{Authorization = "Basic $env:TEAM_PAT"}
	}

   # Apply a Type Name so we can use custom format view and custom type extensions
   foreach($item in $resp.value) {
      _applyTypes -item $item
   }

   Write-Output $resp.value
}

Export-ModuleMember -Alias * -Function Get-CloudSubscription