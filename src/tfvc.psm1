Set-StrictMode -Version Latest

# Load common code
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$here\common.ps1"

# Apply types to the returned objects so format and type files can
# identify the object and act on it.
function _applyTypesToTfvcBranch {
   param($item)

   $item.PSObject.TypeNames.Insert(0, 'Team.TfvcBranch')
}

function Get-VSTeamTfvcRootBranch {
   [CmdletBinding()]
   param(
      [parameter(Mandatory = $false)]
      [switch] $IncludeChildren = $false,

      [parameter(Mandatory = $false)]
      [switch] $IncludeDeleted = $false
   )

   process {
      $queryString = [ordered]@{
         includeChildren = $IncludeChildren;
         includeDeleted = $IncludeDeleted;
      }

      $resp = _callAPI -Area tfvc -Resource branches -QueryString $queryString -Version $([VSTeamVersions]::Tfvc)

      if ($resp | Get-Member -Name value -MemberType Properties) {
         foreach ($item in $resp.value) {
            _applyTypesToTfvcBranch -item $item
         }

         Write-Output $resp.value
      }
      else {
         _applyTypesToTfvcBranch -item $resp
         
         Write-Output $resp
      }
   }
}

function Get-VSTeamTfvcBranch {
   [CmdletBinding()]
   param(
      [parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
      [string[]] $Path,
      
      [parameter(Mandatory = $false)]
      [switch] $IncludeChildren = $false,

      [parameter(Mandatory = $false)]
      [switch] $IncludeParent = $false,

      [parameter(Mandatory = $false)]
      [switch] $IncludeDeleted = $false
   )

   process {
      foreach ($item in $Path) {
         $queryString = [ordered]@{
            includeChildren = $IncludeChildren;
            includeParent = $IncludeParent;
            includeDeleted = $IncludeDeleted;
         }

         $resp = _callAPI -Area tfvc -Resource branches -Id $item -QueryString $queryString -Version $([VSTeamVersions]::Tfvc)

         _applyTypesToTfvcBranch -item $resp
            
         Write-Output $resp
      }
   }
}

Set-Alias Get-TfvcRootBranch Get-VSTeamTfvcRootBranch
Set-Alias Get-TfvcBranch Get-VSTeamTfvcBranch

Export-ModuleMember `
   -Function Get-VSTeamTfvcRootBranch, Get-VSTeamTfvcBranch `
   -Alias Get-TfvcRootBranch, Get-TfvcBranch