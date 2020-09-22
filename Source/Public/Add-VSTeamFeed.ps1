# Adds a new feed to package management.
#
# Get-VSTeamOption 'packaging' 'feeds' -subDomain 'feeds'
# id              : c65009a7-474a-4ad1-8b42-7d852107ef8c
# area            : Packaging
# resourceName    : Feeds
# routeTemplate   : {project}/_apis/{area}/{resource}/{feedId}
# http://bit.ly/Add-VSTeamFeed

function Add-VSTeamFeed {
   [CmdletBinding(HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Add-VSTeamFeed')]
   param (
      [Parameter(Position = 0, Mandatory = $true)]
      [string] $Name,

      [Parameter(Position = 1)]
      [string] $Description,

      [switch] $EnableUpstreamSources,

      [switch] $showDeletedPackageVersions
   )

   process {
      $body = @{
         name                       = $Name
         description                = $Description
         hideDeletedPackageVersions = $true
      }

      if ($showDeletedPackageVersions.IsPresent) {
         $body.hideDeletedPackageVersions = $false
      }

      if ($EnableUpstreamSources.IsPresent) {
         $body.upstreamEnabled = $true
         $body.upstreamSources = @(
            @{
               id                 = [System.Guid]::NewGuid()
               name               = 'npmjs'
               protocol           = 'npm'
               location           = 'https://registry.npmjs.org/'
               upstreamSourceType = 1
            },
            @{
               id                 = [System.Guid]::NewGuid()
               name               = 'nuget.org'
               protocol           = 'nuget'
               location           = 'https://api.nuget.org/v3/index.json'
               upstreamSourceType = 1
            }
         )
      }

      $bodyAsJson = $body | ConvertTo-Json -Compress -Depth 100

      # Call the REST API
      $resp = _callAPI -Method POST -subDomain "feeds" `
         -Area "packaging" `
         -Resource "feeds" `
         -body $bodyAsJson `
         -Version $(_getApiVersion Packaging)

      Write-Output [vsteam_lib.Feed]::new($resp)
   }
}