Set-StrictMode -Version Latest

# Load common code
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$here\common.ps1"

function _buildURL {
   param(
      [parameter(Mandatory = $true)]
      [string] $projectName,
      [int] $id
   )

   _hasAccount

   $version = $VSTeamVersionTable.DistributedTask
   $resource = "/distributedtask/queues"
   $instance = $VSTeamVersionTable.Account

   if ($id) {
      $resource += "/$id"
   }

   # Build the url to list the projects
   return $instance + "/$projectName" + '/_apis' + $resource + '?api-version=' + $version
}

# Apply types to the returned objects so format and type files can
# identify the object and act on it.
function _applyTypes {
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
         try {
            $resp = _callAPI -ProjectName $ProjectName -Id $id -Area distributedtask -Resource queues `
               -Version $VSTeamVersionTable.DistributedTask
         
            _applyTypes -item $resp

            Write-Output $resp  
         }
         catch {
            throw $_
         }
      }
      else {        
         $resp = _callAPI -ProjectName $projectName -Area distributedtask -Resource queues `
            -QueryString @{ queueName = $queueName; actionFilter = $actionFilter } -Version $VSTeamVersionTable.DistributedTask
         
         # Apply a Type Name so we can use custom format view and custom type extensions
         foreach ($item in $resp.value) {
            _applyTypes -item $item
         }

         Write-Output $resp.value
      }
   }
}

Set-Alias Get-Queue Get-VSTeamQueue

Export-ModuleMember `
   -Function Get-VSTeamQueue `
   -Alias Get-Queue