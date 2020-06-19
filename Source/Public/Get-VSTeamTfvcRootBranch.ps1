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

      $resp = _callAPI -Area tfvc -Resource branches -QueryString $queryString -Version $(_getApiVersion Tfvc)

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