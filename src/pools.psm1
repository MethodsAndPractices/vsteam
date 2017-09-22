Set-StrictMode -Version Latest

# Load common code
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$here\common.ps1"

function _buildURL {
   param(
      [int] $d
   )

   if (-not $env:TEAM_ACCT) {
      throw 'You must call Add-VSTeamAccount before calling any other functions in this module.'
   }

   $version = '3.0-preview.1'
   $resource = "/distributedtask/pools"
   $instance = $env:TEAM_ACCT

   if ($id) {
      $resource += "/$id"
   }

   # Build the url to list the projects
   return $instance + '/_apis' + $resource + '?api-version=' + $version
}

# Apply types to the returned objects so format and type files can
# identify the object and act on it.
function _applyTypes {
   param($item)

   $item.PSObject.TypeNames.Insert(0, 'Team.Pool')

   # The hosted pools in VSTS do not have a createdBy value
   if ($null -ne $item.createdBy) {
      $item.createdBy.PSObject.TypeNames.Insert(0, 'Team.User')
   }

   if ($item.PSObject.Properties.Match('administratorsGroup').count -gt 0) {
      # This is VSTS
      $item.administratorsGroup.PSObject.TypeNames.Insert(0, 'Team.Group')
      $item.serviceAccountsGroup.PSObject.TypeNames.Insert(0, 'Team.Group')
   }
}

function Get-VSTeamPool {
   [CmdletBinding(DefaultParameterSetName = 'List')]
   param(
      [Parameter(ParameterSetName = 'List')]
      [string] $PoolName,
      
      [Parameter(ParameterSetName = 'List')]
      [ValidateSet('None', 'Manage', 'Use')]
      [string] $ActionFilter,
      
      [Parameter(ParameterSetName = 'ByID', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [Alias('PoolID')]
      [string] $Id
   )

   process {

      if ($id) {
         # Build the url
         $url = _buildURL -id $id

         # Call the REST API
         if (_useWindowsAuthenticationOnPremise) {
            $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Uri $url -UseDefaultCredentials
         }
         else {
            $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Uri $url -Headers @{Authorization = "Basic $env:TEAM_PAT"}
         }

         _applyTypes -item $resp

         Write-Output $resp
      }
      else {
         # Build the url
         $url = _buildURL

         if (_useWindowsAuthenticationOnPremise) {
            $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Uri $url -UseDefaultCredentials
         }
         else {
            $resp = Invoke-RestMethod -UserAgent (_getUserAgent) -Uri $url -Headers @{Authorization = "Basic $env:TEAM_PAT"}
         }

         # Apply a Type Name so we can use custom format view and custom type extensions
         foreach ($item in $resp.value) {
            _applyTypes -item $item
         }

         # Call the REST API
         Write-Output $resp.value
      }
   }
}

Set-Alias Get-Pool Get-VSTeamPool

Export-ModuleMember -Alias * -Function Get-VSTeamPool