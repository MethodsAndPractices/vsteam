function Get-VSTeamGitRef {
   [CmdletBinding()]
   param (
      [Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true, Position = 0)]
      [Alias('Id')]
      [guid] $RepositoryID,

      [string] $Filter,

      [string] $FilterContains,

      [int] $Top,

      [string] $ContinuationToken,

      [Parameter(Mandatory = $true, Position = 1, ValueFromPipelineByPropertyName = $true)]
      [ProjectValidateAttribute()]
      [ArgumentCompleter([ProjectCompleter])]
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
            $obj += [VSTeamRef]::new($item, $ProjectName)
         }

         Write-Output $obj
      }
      catch {
         throw $_
      }
   }
}
