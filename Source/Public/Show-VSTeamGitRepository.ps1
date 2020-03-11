function Show-VSTeamGitRepository {
   [CmdletBinding()]
   param (
      [Parameter(ValueFromPipelineByPropertyName = $true)]
      [string] $RemoteUrl
   )

   DynamicParam {
      _buildProjectNameDynamicParam -mandatory $false
   }

   process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      if ($RemoteUrl) {
         Show-Browser $RemoteUrl
      }
      else {
         Show-Browser "$(_getInstance)/_git/$ProjectName"
      }
   }
}