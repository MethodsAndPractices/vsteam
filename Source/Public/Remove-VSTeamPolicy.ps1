function Remove-VSTeamPolicy {
   [CmdletBinding(SupportsShouldProcess = $true)]
   param(
      [parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
      [int[]] $Id,

      [switch] $Force,

      [Parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
      [ProjectValidateAttribute()]
      [ArgumentCompleter([ProjectCompleter])]
      [string] $ProjectName
   )

   process {
      foreach ($item in $id) {
         if ($Force -or $pscmdlet.ShouldProcess($item, "Delete Policy")) {
            try {
               _callAPI -Method Delete -ProjectName $ProjectName `
                  -Area policy `
                  -Resource configurations `
                  -Id $item `
                  -Version $(_getApiVersion Policy) | Out-Null

               Write-Output "Deleted policy $item"
            }
            catch {
               _handleException $_
            }
         }
      }
   }
}
