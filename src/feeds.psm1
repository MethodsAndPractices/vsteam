Set-StrictMode -Version Latest

# Load common code
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$here\common.ps1"

function _supportsFeeds {
   if (-not [VSTeamVersions]::Packaging) {
      throw 'This account does not support packages.'
   } 
}

function Remove-VSTeamFeed {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
   param (
      [Parameter(ParameterSetName = 'ByID', Position = 0, Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
      [Alias('FeedId')]
      [string[]] $Id,

      # Forces the command without confirmation
      [switch] $Force
   )

   process {
      # Thi swill throw if this account does not support feeds
      _supportsFeeds

      foreach ($item in $id) {

         if ($Force -or $pscmdlet.ShouldProcess($item, "Delete Package Feed")) {
            # Call the REST API
            _callAPI -subDomain feeds -Method Delete -Id $item -Area packaging -Resource feeds -Version $([VSTeamVersions]::Packaging) | Out-Null
   
            Write-Output "Deleted Feed $item"
         }
      }
   }
}


function Get-VSTeamFeed {
   [CmdletBinding(DefaultParameterSetName = 'List')]
   param (
      [Parameter(ParameterSetName = 'ByID', Position = 0)]
      [Alias('FeedId')]
      [string[]] $Id
   )

   process {
      # Thi swill throw if this account does not support feeds
      _supportsFeeds

      if ($id) {
         foreach ($item in $id) {
            $resp = _callAPI -subDomain feeds -Id $item -Area packaging -Resource feeds -Version $([VSTeamVersions]::Packaging)
            
            Write-Verbose $resp
            $item = [VSTeamFeed]::new($resp)

            Write-Output $item
         }
      }
      else {
         $resp = _callAPI -subDomain feeds -Area packaging -Resource feeds -Version $([VSTeamVersions]::Packaging)
         
         $objs = @()

         foreach ($item in $resp.value) {
            Write-Verbose $item
            $objs += [VSTeamFeed]::new($item)
         }
   
         Write-Output $objs
      }
   }
}

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
      # Thi swill throw if this account does not support feeds
      _supportsFeeds

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
         -Method Post -ContentType 'application/json' -body $bodyAsJson -Version $([VSTeamVersions]::Packaging)

      return [VSTeamFeed]::new($resp)
   }
}

function Show-VSTeamFeed {
   [CmdletBinding()]
   param(
      [Parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Position = 0)]
      [Alias('ID')]
      [string] $Name
   )

   process {
      _hasAccount

      Show-Browser "$([VSTeamVersions]::Account)/_packaging?feed=$Name&_a=feed"
   }
}


Set-Alias Get-Feed Get-VSTeamFeed
Set-Alias Add-Feed Add-VSTeamFeed
Set-Alias Show-Feed Show-VSTeamFeed
Set-Alias Remove-Feed Remove-VSTeamFeed

Export-ModuleMember `
   -Function Get-VSTeamFeed, Add-VSTeamFeed, Show-VSTeamFeed, Remove-VSTeamFeed `
   -Alias Get-Feed, Add-Feed, Show-Feed, Remove-Feed