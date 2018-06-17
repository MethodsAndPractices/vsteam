Set-StrictMode -Version Latest

# Load common code
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$here\common.ps1"

# Apply types to the returned objects so format and type files can
# identify the object and act on it.
function _applyTypesToPool {
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
         $resp = _callAPI -Area distributedtask -Resource pools -Id $id -Version $VSTeamVersionTable.DistributedTask
         
         _applyTypesToPool -item $resp

         Write-Output $resp
      }
      else {
         $resp = _callAPI -Area distributedtask -Resource pools -Version $VSTeamVersionTable.DistributedTask

         # Apply a Type Name so we can use custom format view and custom type extensions
         foreach ($item in $resp.value) {
            _applyTypesToPool -item $item
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