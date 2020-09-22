function Remove-VSTeamWorkItem {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High", DefaultParameterSetName = 'ByID',
    HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Remove-VSTeamWorkItem')]
   param(
      [Parameter(Mandatory = $true, ValueFromPipeline = $true, Position = 0)]
      [int[]] $Id,

      [switch] $Destroy,

      [switch] $Force
   )

   Process {
      # Call the REST API
      foreach ($item in $Id) {
         if ($Force -or $pscmdlet.ShouldProcess($item, "Delete Work Item")) {
            try {
               _callAPI -Method DELETE `
                  -Area "wit" `
                  -Resource "workitems" `
                  -id $item `
                  -Querystring @{ destroy = $Destroy } `
                  -Version $(_getApiVersion Core) | Out-Null

               Write-Output "Deleted Work item with ID $item"
            }
            catch {
               _handleException $_
            }
         }
      }
   }
}