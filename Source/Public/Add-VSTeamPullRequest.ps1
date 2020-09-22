# Creates a new Pull Request.
#
# id              : 88aea7e8-9501-45dd-ac58-b069aa73b926
# area            : git
# resourceName    : repositories
# routeTemplate   : _apis/{area}/{projectId}/{resource}/{repositoryId}
# http://bit.ly/Add-VSTeamPullRequest

function Add-VSTeamPullRequest {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Low",
    HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Add-VSTeamPullRequest')]
   param(
      [Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true, Position = 0)]
      [Alias('Id')]
      [Guid] $RepositoryId,

      [Parameter(Mandatory = $true, HelpMessage = "Should be a ref like refs/heads/MyBranch")]
      [ValidatePattern('^refs/.*')]
      [string] $SourceRefName,

      [Parameter(Mandatory = $true, HelpMessage = "Should be a ref like refs/heads/MyBranch")]
      [ValidatePattern('^refs/.*')]
      [string] $TargetRefName,

      [Parameter(Mandatory = $true)]
      [string] $Title,

      [Parameter(Mandatory = $true)]
      [string] $Description,

      [Parameter()]
      [switch] $Draft,

      [Parameter()]
      [switch] $Force,

      [Parameter(ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName
   )

   process {
      Write-Verbose "Add-VSTeamPullRequest"

      $body = '{"sourceRefName": "' + $SourceRefName + '", "targetRefName": "' + $TargetRefName + '", "title": "' + $Title + '", "description": "' + $Description + '", "isDraft": ' + $Draft.ToString().ToLower() + '}'

      Write-Verbose $body

      # Call the REST API
      if ($force -or $pscmdlet.ShouldProcess($Title, "Add Pull Request")) {

         try {
            Write-Debug 'Add-VSTeamPullRequest Call the REST API'
            $resp = _callAPI -Method POST -ProjectName $ProjectName `
               -Area "git" `
               -Resource "repositories" `
               -Id "$RepositoryId/pullrequests" `
               -Body $body `
               -Version $(_getApiVersion Git)

            _applyTypesToPullRequests -item $resp

            Write-Output $resp
         }
         catch {
            _handleException $_
         }
      }
   }
}