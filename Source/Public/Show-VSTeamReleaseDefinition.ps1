function Show-VSTeamReleaseDefinition {
   [CmdletBinding()]
   param(
      [Parameter(ParameterSetName = 'ByID', ValueFromPipelineByPropertyName = $true)]
      [Alias('ReleaseDefinitionID')]
      [int] $Id
   )

   DynamicParam {
      _buildProjectNameDynamicParam
   }

   process {
      Write-Debug 'Show-VSTeamReleaseDefinition Process'

      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      # Build the url
      $url = "$([VSTeamVersions]::Account)/$ProjectName/_release"

      if ($id) {
         $url += "?definitionId=$id"
      }

      Show-Browser $url
   }
}