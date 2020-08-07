function Get-VSTeamFeed {
   [CmdletBinding(DefaultParameterSetName = 'List')]
   param (
      [Parameter(ParameterSetName = 'ByID', Position = 0)]
      [Alias('FeedId')]
      [string[]] $Id
   )

   process {
      $commonArgs = @{
         subDomain = 'feeds'
         area      = 'packaging'
         resource  = 'feeds'
         NoProject = $true
         version   = $(_getApiVersion Packaging)
      }

      if ($id) {
         foreach ($item in $id) {
            $resp = _callAPI @commonArgs -Id $item

            Write-Verbose $resp
            $item = [VSTeamFeed]::new($resp)

            Write-Output $item
         }
      }
      else {
         $resp = _callAPI @commonArgs

         $objs = @()

         foreach ($item in $resp.value) {
            Write-Verbose $item
            $objs += [VSTeamFeed]::new($item)
         }

         Write-Output $objs
      }
   }
}