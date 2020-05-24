function Add-VSTeamFeed {
   [CmdletBinding()]
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

      $bodyAsJson = $body | ConvertTo-Json

      # Call the REST API
      $resp = _callAPI -subDomain feeds -Area packaging -Resource feeds `
         -Method Post -ContentType 'application/json' -body $bodyAsJson -Version $(_getApiVersion Packaging)

      return [VSTeamFeed]::new($resp)
   }
}