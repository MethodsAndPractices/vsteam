Set-StrictMode -Version Latest

# Load common code
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$here\common.ps1"

# Apply types to the returned objects so format and type files can
# identify the object and act on it.
function _applyTypesWorkItemType {
   param($item)

   $item.PSObject.TypeNames.Insert(0, 'Team.WorkItemType')
}

function Get-VSTeamWorkItemType {
   [CmdletBinding(DefaultParameterSetName = 'List')]
   param()

   DynamicParam {
      $dp = _buildProjectNameDynamicParam

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
      $rp = _buildDynamicParam -ParameterName $ParameterName -arrSet $arrSet -ParameterSetName 'ByType'
      $dp.Add($ParameterName, $rp)

      $dp
   }

   Process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]
      $WorkItemType = $PSBoundParameters["WorkItemType"]

      # Call the REST API
      if ($WorkItemType) {
         $resp = _callAPI -ProjectName $ProjectName -Area 'wit' -Resource 'workitemtypes'  `
            -Version $([VSTeamVersions]::Core) -id $WorkItemType

         # This call returns JSON with "": which causes the ConvertFrom-Json to fail.
         # To replace all the "": with "_end":
         $resp = $resp.Replace('"":', '"_end":') | ConvertFrom-Json

         _applyTypesWorkItemType -item $resp

         return $resp
      }
      else {      
         $resp = _callAPI -ProjectName $ProjectName -Area 'wit' -Resource 'workitemtypes'  `
            -Version $([VSTeamVersions]::Core)

         # This call returns JSON with "": which causes the ConvertFrom-Json to fail.
         # To replace all the "": with "_end":
         $resp = $resp.Replace('"":', '"_end":') | ConvertFrom-Json
      
         # Apply a Type Name so we can use custom format view and custom type extensions
         foreach ($item in $resp.value) {
            _applyTypesWorkItemType -item $item
         }

         return $resp.value
      }
   }
}

Set-Alias Get-WorkItemType Get-VSTeamWorkItemType

Export-ModuleMember `
   -Function Get-VSTeamWorkItemType `
   -Alias Get-WorkItemType