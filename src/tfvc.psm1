Set-StrictMode -Version Latest

# Load common code
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$here\common.ps1"

# Apply types to the returned objects so format and type files can
# identify the object and act on it.
function _applyTypes {
   param($item)

   $item.PSObject.TypeNames.Insert(0, 'Team.TfvcBranch')
}

function Get-VSTeamTfvcBranches {
   [CmdletBinding()]
   param(
      [parameter(Mandatory = $false)]
      [switch] $IncludeDeleted = $false
   )

   DynamicParam {
      _buildProjectNameDynamicParam
   }

   process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      $queryString = @{
         includeDeleted = $IncludeDeleted;
      }

      $resp = _callAPI -ProjectName $ProjectName -Area tfvc -Resource branches -QueryString $queryString -Version $VSTeamVersionTable.Tfvc

      foreach ($item in $resp.value) {
         _applyTypes -item $item
      }

      Write-Output $resp.value
   }
}

function Get-VSTeamTfvcBranch {
   [CmdletBinding()]
   param(
      [parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
      [string[]] $Path,
      
      [parameter(Mandatory = $false)]
      [switch] $IncludeDeleted = $false,

      [parameter(Mandatory = $false)]
      [switch] $IncludeChildren = $false,

      [parameter(Mandatory = $false)]
      [switch] $IncludeParent = $false
   )

   DynamicParam {
      _buildProjectNameDynamicParam
   }

   process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      foreach ($item in $Path)
      {
         $queryString = [ordered]@{
            path = $item;
            includeDeleted = $IncludeDeleted;
            includeChildren = $IncludeChildren;
            includeParent = $IncludeParent;
         }

         $resp = _callAPI -ProjectName $ProjectName -Area tfvc -Resource branches -QueryString $queryString -Version $VSTeamVersionTable.Tfvc

         _applyTypes -item $resp
            
         Write-Output $resp
      }
   }
}

Set-Alias Get-TfvcBranches Get-VSTeamTfvcBranches
Set-Alias Get-TfvcBranch Get-VSTeamTfvcBranch

Export-ModuleMember `
   -Function Get-VSTeamTfvcBranches, Get-VSTeamTfvcBranch `
   -Alias Get-TfvcBranches, Get-TfvcBranch