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
            $resp = _callAPI -NoProject -subDomain feeds -Id $item -Area packaging -Resource feeds -Version $([VSTeamVersions]::Packaging)

            Write-Verbose $resp
            $item = [VSTeamFeed]::new($resp)

            Write-Output $item
         }
      }
      else {
         $resp = _callAPI -NoProject -subDomain feeds -Area packaging -Resource feeds -Version $([VSTeamVersions]::Packaging)

         $objs = @()

         foreach ($item in $resp.value) {
            Write-Verbose $item
            $objs += [VSTeamFeed]::new($item)
         }

         Write-Output $objs
      }
   }
}