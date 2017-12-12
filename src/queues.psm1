Set-StrictMode -Version Latest

# Load common code
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$here\common.ps1"

# Apply types to the returned objects so format and type files can
# identify the object and act on it.
function _applyTypesToQueue {
   param($item)

   $item.PSObject.TypeNames.Insert(0, 'Team.Queue')
   $item.pool.PSObject.TypeNames.Insert(0, 'Team.Pool')
}

function Get-VSTeamQueue {
   [CmdletBinding(DefaultParameterSetName = 'List')]
   param(
      [Parameter(ParameterSetName = 'List')]
      [string] $queueName,
      [Parameter(ParameterSetName = 'List')]
      [ValidateSet('None', 'Manage', 'Use')]
      [string] $actionFilter,
      [Parameter(ParameterSetName = 'ByID')]
      [Alias('QueueID')]
      [string] $id
   )

   DynamicParam {
      _buildProjectNameDynamicParam
   }

   process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      if ($id) {
         $resp = _callAPI -ProjectName $ProjectName -Id $id -Area distributedtask -Resource queues `
            -Version $VSTeamVersionTable.DistributedTask
         
         _applyTypesToQueue -item $resp

         Write-Output $resp  
      }
      else {        
         $resp = _callAPI -ProjectName $projectName -Area distributedtask -Resource queues `
            -QueryString @{ queueName = $queueName; actionFilter = $actionFilter } -Version $VSTeamVersionTable.DistributedTask
         
         # Apply a Type Name so we can use custom format view and custom type extensions
         foreach ($item in $resp.value) {
            _applyTypesToQueue -item $item
         }

         Write-Output $resp.value
      }
   }
}

Set-Alias Get-Queue Get-VSTeamQueue

Export-ModuleMember `
   -Function Get-VSTeamQueue `
   -Alias Get-Queue