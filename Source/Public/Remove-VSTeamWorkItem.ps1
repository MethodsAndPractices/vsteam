function Remove-VSTeamWorkItem {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High", DefaultParameterSetName = 'ByID')]
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
               _callAPI -Method Delete -Area wit -Resource workitems `
                  -Version $(_getApiVersion Core) -id $item `
                  -Querystring @{
                  destroy = $Destroy
               } | Out-Null

               Write-Output "Deleted Work item with ID $item"
            }
            catch {
               _handleException $_
            }
         }
      }
   }
}