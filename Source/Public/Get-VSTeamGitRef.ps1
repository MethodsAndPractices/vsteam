function Get-VSTeamGitRef {
   [CmdletBinding()]
   param (
      [Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
      [Alias('Id')]
      [guid] $RepositoryID,
      [Parameter()]
      [string] $Filter,
      [Parameter()]
      [string] $FilterContains,
      [Parameter()]
      [int] $Top,
      [Parameter()]
      [string] $ContinuationToken
   )

   DynamicParam {
      _buildProjectNameDynamicParam
   }

   process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      try {

         $queryString = @{
            '$top'              = $Top
            'filter'            = $Filter
            'filterContains'    = $FilterContains
            'continuationToken' = $continuationToken
         }
         
         $url = _buildRequestURI -Area git -Resource repositories -Version $([VSTeamVersions]::Git) -ProjectName $ProjectName -Id "$RepositoryID/refs" 
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