Set-StrictMode -Version Latest

# Load common code
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$here\common.ps1"

# Apply types to the returned objects so format and type files can
# identify the object and act on it.
function _applyTypes {
   param($item)

   $item.PSObject.TypeNames.Insert(0, 'Team.WorkItem')
}

function Add-VSTeamWorkItem {
   [CmdletBinding()]
   param(
      [Parameter(Mandatory = $true)]
      [string]$Title
   )

   DynamicParam {
      $dp = _buildProjectNameDynamicParam -mandatory $true

      # If they have not set the default project you can't find the
      # validateset so skip that check. However, we still need to give
      # the option to pass a WorkItemType to use.
      if ($Global:PSDefaultParameterValues["*:projectName"]) {
         $wittypes = _getWorkItemTypes -ProjectName $Global:PSDefaultParameterValues["*:projectName"]
         $arrSet = $wittypes
      }
      else {
         Write-Verbose 'Call Set-VSTeamDefaultProject for Tab Complete of WorkItemType'
         $wittypes = $null
         $arrSet = $null
      }

      $ParameterName = 'WorkItemType'
      $rp = _buildDynamicParam -ParameterName $ParameterName -arrSet $arrSet
      $dp.Add($ParameterName, $rp)

      $dp
   }

   Process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]
      $WorkItemType = $PSBoundParameters["WorkItemType"]

      $body = '[{"op": "add", "path": "/fields/System.Title", "from": null, "value": "' + $Title + '"}]'

      # Call the REST API
      $resp = _callAPI -ProjectName $ProjectName -Area 'wit' -Resource 'workitems'  `
         -Version $VSTeamVersionTable.Core -id $WorkItemType -Method Post `
         -ContentType 'application/json' -Body $body

      _applyTypes -item $resp

      return $resp
   }
}

Set-Alias Add-WorkItem Add-VSTeamWorkItem

Export-ModuleMember `
   -Function Add-VSTeamWorkItem `
   -Alias Add-WorkItem