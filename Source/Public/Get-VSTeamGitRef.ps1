function Get-VSTeamGitRef {
   [CmdletBinding()]
   param (
      [Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
      [Alias('Id')]
      [guid] $RepositoryID
   )

   DynamicParam {
      _buildProjectNameDynamicParam
   }

   process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      try {
         $resp = _callAPI -ProjectName $ProjectName -Id "$RepositoryID/refs" -Area git -Resource repositories -Version $([VSTeamVersions]::Git)

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