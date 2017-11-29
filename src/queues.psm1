Set-StrictMode -Version Latest

# Load common code
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$here\common.ps1"

function _buildURL {
   param(
      [parameter(Mandatory=$true)]
      [string] $projectName,
      [int] $id
   )

   if(-not $VSTeamVersionTable.Account) {
      throw 'You must call Add-VSTeamAccount before calling any other functions in this module.'
   }

   $version = $VSTeamVersionTable.DistributedTask
   $resource = "/distributedtask/queues"
   $instance = $VSTeamVersionTable.Account

   if($id) {
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
   [CmdletBinding(DefaultParameterSetName='List')]
   param(
      [Parameter(ParameterSetName='List')]
      [string] $queueName,
      [Parameter(ParameterSetName='List')]
      [ValidateSet('None','Manage', 'Use')]
      [string] $actionFilter,
      [Parameter(ParameterSetName='ByID')]
      [Alias('QueueID')]
      [string] $id
   )

   DynamicParam {
      _buildProjectNameDynamicParam
   }

   process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      if($id) {
         # Build the url
         $url = _buildURL -projectName $projectName -id $id
         
         $resp = _get -url $url
         
         _applyTypes -item $resp

         # Call the REST API
         Write-Output $resp
      } else {
         # Build the url
         $url = _buildURL -projectName $projectName

         if ($queueName) {
            $url += "&queueName=$queueName"
         }

         if ($actionFilter) {
            $url += "&actionFilter=$actionFilter"
         }

         # Call the REST API
         $resp = _get -url $url
         
         # Apply a Type Name so we can use custom format view and custom type extensions
         foreach($item in $resp.value) {
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