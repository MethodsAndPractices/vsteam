function Show-VSTeamGitRepository {
   [CmdletBinding()]
   param (
      [Parameter(ValueFromPipelineByPropertyName = $true)]
      [string] $RemoteUrl,

      [Parameter(Position = 0, ValueFromPipelineByPropertyName = $true)]
      [ProjectValidateAttribute()]
      [ArgumentCompleter([ProjectCompleter])]
      [string] $ProjectName
   )

   process {
      if ($RemoteUrl) {
         Show-Browser $RemoteUrl
      }
      else {
         Show-Browser "$(_getInstance)/_git/$ProjectName"
      }
   }
}
