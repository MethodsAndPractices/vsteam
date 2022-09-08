function Get-VSTeamFeed {
   [CmdletBinding(DefaultParameterSetName = 'List',
    HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Get-VSTeamFeed')]
   param (
      [Parameter(ParameterSetName = 'ByID', Position = 0)]
      [Alias('FeedId')]
      [string[]] $Id,

      [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
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
      }else{
         $commonArgs.NoProject = $true
      }

      if ($id) {
         foreach ($item in $id) {
            $resp = _callAPI @commonArgs -Id $item

            Write-Verbose $resp
            $item = [vsteam_lib.Feed]::new($resp)

            Write-Output $item
         }
      }
      else {
         $resp = _callAPI @commonArgs

         $objs = @()

         foreach ($item in $resp.value) {
            Write-Verbose $item
            $objs += [vsteam_lib.Feed]::new($item)
         }

         Write-Output $objs
      }
   }
}