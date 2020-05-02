function Remove-VSTeamFeed {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
   param (
      [Parameter(ParameterSetName = 'ByID', Position = 0, Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
      [Alias('FeedId')]
      [string[]] $Id,

      [switch] $Force
   )
   process {
      # This will throw if this account does not support feeds
      _supportsFeeds

      foreach ($item in $id) {
         if ($Force -or $pscmdlet.ShouldProcess($item, "Delete Package Feed")) {
            # Call the REST API
            _callAPI -subDomain feeds -Method Delete -Id $item -Area packaging -Resource feeds -Version  $(_getApiVersion Packaging) | Out-Null

            Write-Output "Deleted Feed $item"
         }
      }
   }
}
