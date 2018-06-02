Set-StrictMode -Version Latest

# Load common code
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$here\common.ps1"

# Apply types to the returned objects so format and type files can
# identify the object and act on it.
function _applyTypes {
   param($item)

   $item.PSObject.TypeNames.Insert(0, 'Team.WorkItemType')
}

function Get-VSTeamWorkItemType {
   [CmdletBinding()]
   param()

   DynamicParam {
      _buildProjectNameDynamicParam -mandatory $false
   }

   Process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      # Call the REST API
      $resp = _callAPI -ProjectName $ProjectName -Area 'wit' -Resource 'workitemtypes'  `
         -Version $VSTeamVersionTable.Core

      # This call returns JSON with "": which causes the ConvertFrom-Json to fail.
      # To replace all the "": with "_end":
      $resp = $resp.Replace('"":', '"_end":') | ConvertFrom-Json
      
      # Apply a Type Name so we can use custom format view and custom type extensions
      foreach ($item in $resp.value) {
         _applyTypes -item $item
      }

      return $resp.value
   }
}

Set-Alias Get-WorkItemType Get-VSTeamWorkItemType

Export-ModuleMember `
   -Function Get-VSTeamWorkItemType `
   -Alias Get-WorkItemType