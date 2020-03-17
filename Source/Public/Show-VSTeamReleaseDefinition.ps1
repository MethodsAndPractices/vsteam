function Show-VSTeamReleaseDefinition {
   [CmdletBinding()]
   param(
      [Parameter(ParameterSetName = 'ByID', ValueFromPipelineByPropertyName = $true)]
      [Alias('ReleaseDefinitionID')]
      [int] $Id,
      [Parameter(Mandatory=$true, Position = 0 )]
      [ValidateProjectAttribute()]
      [ArgumentCompleter([ProjectCompleter])]
      $ProjectName
   )
   process {
      Write-Debug 'Show-VSTeamReleaseDefinition Process'

      # Build the url
      $url = "$(_getInstance)/$ProjectName/_release"

      if ($id) {
         $url += "?definitionId=$id"
      }
      Show-Browser $url
   }
}
