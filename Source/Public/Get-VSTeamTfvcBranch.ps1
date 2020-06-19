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

         $resp = _callAPI -Area tfvc -Resource branches -Id $item -QueryString $queryString -Version $(_getApiVersion Tfvc)

         _applyTypesToTfvcBranch -item $resp

         Write-Output $resp
      }
   }
}