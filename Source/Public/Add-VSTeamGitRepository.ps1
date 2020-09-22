# Adds a Git repository to your Azure DevOps or Team Foundation Server account.
#
# Get-VSTeamOption 'git' 'repositories'
# id              : 225f7195-f9c7-4d14-ab28-a83f7ff77e1f
# area            : git
# resourceName    : repositories
# routeTemplate   : {project}/_apis/{area}/{resource}/{repositoryId}
# http://bit.ly/Add-VSTeamGitRepository

function Add-VSTeamGitRepository {
   [CmdletBinding(HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Add-VSTeamGitRepository')]
   param(
      [parameter(Mandatory = $true)]
      [string] $Name,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName
   )
   process {
      $body = '{"name": "' + $Name + '"}'

      try {
         # Call the REST API
         $resp = _callAPI -Method POST -ProjectName $ProjectName `
            -Area "git" `
            -Resource "repositories" `
            -Body $body `
            -Version $(_getApiVersion Git)

         # Storing the object before you return it cleaned up the pipeline.
         # When I just write the object from the constructor each property
         # seemed to be written
         $repo = [vsteam_lib.GitRepository]::new($resp, $ProjectName)

         Write-Output $repo
      }
      catch {
         _handleException $_
      }
   }
}
