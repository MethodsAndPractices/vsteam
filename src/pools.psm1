Set-StrictMode -Version Latest

# Load common code
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$here\common.ps1"

function _buildURL {
   param(
      [int] $id
   )

   if (-not $VSTeamVersionTable.Account) {
      throw 'You must call Add-VSTeamAccount before calling any other functions in this module.'
   }

   $version = $VSTeamVersionTable.DistributedTask
   $resource = "/distributedtask/pools"
   $instance = $VSTeamVersionTable.Account

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
      [Parameter(ParameterSetName = 'ByID', Mandatory = $true, ValueFromPipelineByPropertyName = $true, Position = 1)]
      [Alias('PoolID')]
      [string] $Id
   )

   process {

      if ($id) {
         # Build the url
         $url = _buildURL -id $id

         # Call the REST API
         $resp = _get -url $url
         
         _applyTypes -item $resp

         Write-Output $resp
      }
      else {
         # Build the url
         $url = _buildURL

         $resp = _get -url $url

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

Export-ModuleMember `
 -Function Get-VSTeamPool `
 -Alias Get-Pool