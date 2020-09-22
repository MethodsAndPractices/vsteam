function Get-VSTeamGitRef {
   [CmdletBinding(HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Get-VSTeamGitRef')]
   param (
      [Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true, Position = 0)]
      [Alias('Id')]
      [guid] $RepositoryID,

      [string] $Filter,

      [string] $FilterContains,

      [int] $Top,

      [string] $ContinuationToken,

      [Parameter(Mandatory = $true, Position = 1, ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName
   )
   process {
      try {

         $queryString = @{
            '$top'              = $Top
            'filter'            = $Filter
            'filterContains'    = $FilterContains
            'continuationToken' = $continuationToken
         }

         $url = _buildRequestURI -Area git -Resource repositories -Version $(_getApiVersion Git) -ProjectName $ProjectName -Id "$RepositoryID/refs"
         $resp = _callAPI -url $url -QueryString $queryString

         $obj = @()

         foreach ($item in $resp.value) {
            $obj += [vsteam_lib.GitRef]::new($item, $ProjectName)
         }

         Write-Output $obj
      }
      catch {
         throw $_
      }
   }
}
