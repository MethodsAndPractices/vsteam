function Show-VSTeamGitRepository {
   [CmdletBinding(HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/Show-VSTeamGitRepository')]
   param (
      [Parameter(ValueFromPipelineByPropertyName = $true)]
      [string] $RemoteUrl,

      [Parameter(Position = 0, ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
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
