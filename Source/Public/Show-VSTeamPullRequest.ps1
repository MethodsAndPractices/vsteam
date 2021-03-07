function Show-VSTeamPullRequest {
   [CmdletBinding(HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Show-VSTeamPullRequest')]
   param(
       [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Position = 0)]
       [Alias('PullRequestId')]
       [int] $Id
   )

   process {
       try {
           $pullRequest = Get-VSTeamPullRequest -PullRequestId $Id

           $projectName = [uri]::EscapeDataString($pullRequest.repository.project.name)
           $repositoryId = $pullRequest.repositoryName

           Show-Browser "$(_getInstance)/$projectName/_git/$repositoryId/pullrequest/$Id"
       }
       catch {
           _handleException $_
       }
   }
}