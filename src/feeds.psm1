Set-StrictMode -Version Latest

# Load common code
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$here\common.ps1"

function _supportsFeeds {
   if (-not [VSTeamVersions]::Packaging) {
      throw 'This account does not support packages.'
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
   param ()
   process {
      # Thi swill throw if this account does not support feeds
      _supportsFeeds
   }
}

function Remove-VSTeamFeed {
   param (
      [Parameter(Mandatory = $true)]
      [Alias('FeedId')]
      [string[]] $Id
   )
   process {
      # Thi swill throw if this account does not support feeds
      _supportsFeeds
   }
}


Set-Alias Get-Feed Get-VSTeamFeed
Set-Alias Remove-Feed Remove-VSTeamFeed
Set-Alias Add-Feed Add-VSTeamFeed

Export-ModuleMember `
   -Function Get-VSTeamFeed, Remove-VSTeamFeed, Add-VSTeamFeed `
   -Alias Get-Feed, Remove-Feed, Add-Feed