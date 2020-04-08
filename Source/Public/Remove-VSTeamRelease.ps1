function Remove-VSTeamRelease {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
   param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [int[]] $Id,

      [switch] $Force,

      [Parameter(Mandatory = $true, Position = 0)]
      [ValidateProjectAttribute()]
      [ArgumentCompleter([ProjectCompleter])]
      $ProjectName
   )
   process {
      foreach ($item in $id) {
         if ($force -or $pscmdlet.ShouldProcess($item, "Delete Release")) {
            try {
               # Call the REST API
               _callAPI -Method Delete -SubDomain vsrm -Area release -Resource releases -ProjectName $ProjectName -id $item -Version $(_getApiVersion Release) | Out-Null

               Write-Output "Deleted release $item"
            }
            catch {
               _handleException $_
            }
         }
      }
   }
}
