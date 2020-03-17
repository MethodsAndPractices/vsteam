function Add-VSTeamPullRequest {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Low")]
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

      # Forces the command without confirmation
      [Parameter()]
      [switch] $Force,

      [Parameter( Position = 0 )]
      [ValidateProjectAttribute()]
      [ArgumentCompleter([ProjectCompleter])]
      $ProjectName
   )

   process {
      Write-Verbose "Add-VSTeamPullRequest"
      $body = '{"sourceRefName": "' + $SourceRefName + '", "targetRefName": "' + $TargetRefName + '", "title": "' + $Title + '", "description": "' + $Description + '", "isDraft": ' + $Draft.ToString().ToLower() + '}'

      Write-Verbose $body

      # Call the REST API
      if ($force -or $pscmdlet.ShouldProcess($Title, "Add Pull Request")) {

         try {
            Write-Debug 'Add-VSTeamPullRequest Call the REST API'
            $resp = _callAPI -ProjectName $ProjectName -Area 'git' -Resource 'repositories' -Id "$RepositoryId/pullrequests" `
               -Method Post -ContentType 'application/json;charset=utf-8' -Body $body -Version $([VSTeamVersions]::Release)

            _applyTypesToPullRequests -item $resp

            Write-Output $resp
         }
         catch {
            _handleException $_
         }
      }
   }
}