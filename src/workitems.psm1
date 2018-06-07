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

      # The type has to start with a $
      $WorkItemType = "`$$($PSBoundParameters["WorkItemType"])"

      $body = '[{"op": "add", "path": "/fields/System.Title", "from": null, "value": "' + $Title + '"}]'

      # Call the REST API
      $resp = _callAPI -ProjectName $ProjectName -Area 'wit' -Resource 'workitems'  `
         -Version $VSTeamVersionTable.Core -id $WorkItemType -Method Post `
         -ContentType 'application/json-patch+json' -Body $body

      _applyTypes -item $resp

      return $resp
   }
}

function Get-VSTeamWorkItem {
   [CmdletBinding()]
   param(
      [Parameter(Mandatory = $true)]
      [int[]] $Id
   )

   DynamicParam {
      _buildProjectNameDynamicParam -mandatory $true
   }

   Process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      # Call the REST API
      if ($Id.Count -gt 1) {
         $a = @{
            ids = $id -join ','
         }

         $resp = _callAPI -ProjectName $ProjectName -Area 'wit' -Resource 'workitems'  `
            -Version $VSTeamVersionTable.Core -Body $a

         foreach ($item in $resp.value) {
            _applyTypes -item $item
         }
      }
      else {
         $a = $id[0]
         $resp = _callAPI -ProjectName $ProjectName -Area 'wit' -Resource 'workitems'  `
            -Version $VSTeamVersionTable.Core -id "$a"

         _applyTypes -item $resp
      }

      return $resp
   }
}

Set-Alias Add-WorkItem Add-VSTeamWorkItem
Set-Alias Get-WorkItem Get-VSTeamWorkItem

Export-ModuleMember `
   -Function Add-VSTeamWorkItem, Get-VSTeamWorkItem `
   -Alias Add-WorkItem, Get-WorkItem