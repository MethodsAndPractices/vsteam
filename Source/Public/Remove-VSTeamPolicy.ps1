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
               _callAPI -ProjectName $ProjectName -Method Delete -Id $item -Area policy -Resource configurations -Version  $(_getApiVersion Git) | Out-Null

               Write-Output "Deleted policy $item"
            }
            catch {
               _handleException $_
            }
         }
      }
   }
}
