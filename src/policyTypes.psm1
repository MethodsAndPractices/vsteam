Set-StrictMode -Version Latest

# Load common code
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$here\common.ps1"

# Apply types to the returned objects so format and type files can
# identify the object and act on it.
function _applyTypesToPolicyType {
   param($item)

   $item.PSObject.TypeNames.Insert(0, 'Team.PolicyType')
}

function Get-VSTeamPolicyType {
   [CmdletBinding()]
   param (
      [Parameter(ValueFromPipeline = $true)]
      [guid[]] $Id
   )

   DynamicParam {
      _buildProjectNameDynamicParam -mandatory $true
   }

   process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]
      
      if ($id) {
         foreach ($item in $id) {
            try {
               $resp = _callAPI -ProjectName $ProjectName -Id $item -Area policy -Resource types -Version $VSTeamVersionTable.Git
               
               _applyTypesToPolicyType -item $resp
               
               Write-Output $resp 
            }
            catch {
               throw $_
            }
         }
      }
      else {
         try {
            $resp = _callAPI -ProjectName $ProjectName -Area policy -Resource types -Version $VSTeamVersionTable.Git

            # Apply a Type Name so we can use custom format view and custom type extensions
            foreach ($item in $resp.value) {
               _applyTypesToPolicyType -item $item
            }

            Write-Output $resp.value
         }
         catch {
            throw $_
         }
      }
   }
}

Set-Alias Get-PolicyType Get-VSTeamPolicyType

Export-ModuleMember `
   -Function Get-VSTeamPolicyType `
   -Alias Get-PolicyType