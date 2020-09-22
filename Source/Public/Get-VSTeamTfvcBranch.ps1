# Gets a branch for a given path from TFVC source control.
#
# id              : bc1f417e-239d-42e7-85e1-76e80cb2d6eb
# area            : tfvc
# resourceName    : branches
# routeTemplate   : {project}/_apis/{area}/{resource}/{*path}
# http://bit.ly/Get-VSTeamTfvcBranch

function Get-VSTeamTfvcBranch {
   [CmdletBinding(DefaultParameterSetName = 'List',
    HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Get-VSTeamTfvcBranch')]
   param(
      [parameter(ParameterSetName = 'ByPath', Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
      [string[]] $Path,

      [parameter(Mandatory = $false)]
      [switch] $IncludeChildren = $false,

      [parameter(Mandatory = $false)]
      [switch] $IncludeParent = $false,

      [parameter(Mandatory = $false)]
      [switch] $IncludeDeleted = $false,

      [Parameter(ParameterSetName = 'List', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName
   )

   process {
      $queryString = [ordered]@{
         includeChildren = $IncludeChildren;
         includeParent   = $IncludeParent;
         includeDeleted  = $IncludeDeleted;
      }

      if ($null -eq $Path) {
         $resp = _callAPI -ProjectName $ProjectName `
            -Area "tfvc" `
            -Resource "branches" `
            -QueryString $queryString `
            -Version $(_getApiVersion Tfvc)

         foreach ($item in $resp.value) {
            _applyTypesToTfvcBranch -item $item
         }

         Write-Output $resp.value
      }
      else {
         foreach ($item in $Path) {
            $resp = _callAPI -Area "tfvc" `
               -Resource "branches" `
               -Id $item `
               -QueryString $queryString `
               -Version $(_getApiVersion Tfvc)

            _applyTypesToTfvcBranch -item $resp

            Write-Output $resp
         }
      }
   }
}