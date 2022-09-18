function Get-VSTeamFeed {
   [CmdletBinding(DefaultParameterSetName = 'List',
      HelpUri = 'https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Get-VSTeamFeed')]
   param (
      [Parameter(ParameterSetName = 'ByID', Position = 0)]
      [Alias('FeedId')]
      [string[]] $Id,

      [Parameter(ParameterSetName = 'ByScope', Position = 1)]
      [ValidateSet('organization', 'project')]
      [string] $Scope,

      [Parameter(ParameterSetName = 'ByID', ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName
   )

   process {
      $commonArgs = @{
         subDomain = 'feeds'
         area      = 'packaging'
         resource  = 'feeds'
         version   = $(_getApiVersion Packaging)
      }

      if ($ProjectName) {
         $commonArgs.ProjectName = $ProjectName
      }
      else {
         $commonArgs.NoProject = $true
      }

      if ($PSCmdlet.ParameterSetName -eq 'ByID') {
         foreach ($item in $id) {
            $resp += _callAPI @commonArgs -Id $item
         }
      }
      else {
         $resp = (_callAPI @commonArgs).value
      }

      $feeds = @()
      foreach ($feed in $resp) {
         Write-Verbose $feed
         $feeds += [vsteam_lib.Feed]::new($feed)
      }

      if ($PSCmdlet.ParameterSetName -eq 'ByScope') {

         $orgFeedApiUrl = ("$env:TEAM_ACCT/_apis/packaging/feeds/") -replace 'dev.azure.com', 'feeds.dev.azure.com'
         if ($Scope -eq 'organization') {
            # this part of the url can only be used with the organization scope
            $feeds = $feeds | Where-Object {

            }
         }
         else {
            $feeds = $feeds | Where-Object { $_.Url -notmatch $orgFeedApiUrl }
         }
      }

      Write-Output $feeds
   }
}