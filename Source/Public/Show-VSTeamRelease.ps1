function Show-VSTeamRelease {
   [CmdletBinding(DefaultParameterSetName = 'ById')]
   param(
      [Parameter(ParameterSetName = 'ByID', ValueFromPipelineByPropertyName = $true, Mandatory = $true, Position = 1)]
      [Alias('ReleaseID')]
      [int] $id
   )

   DynamicParam {
      _buildProjectNameDynamicParam
   }

   process {
      Write-Debug 'Show-VSTeamRelease Process'

      if ($id -lt 1) {
         Throw "$id is not a valid id. Value must be greater than 0."
      }

      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      # Build the url
      Show-Browser "$([VSTeamVersions]::Account)/$ProjectName/_release?releaseId=$id"
   }
}