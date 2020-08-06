function Add-VSTeamPolicy {
   [CmdletBinding()]
   param(
      [Parameter(Mandatory = $true)]
      [guid] $type,

      [switch] $enabled,

      [switch] $blocking,

      [Parameter(Mandatory = $true)]
      [hashtable] $settings,

      [ProjectValidateAttribute()]
      [ArgumentCompleter([ProjectCompleter])]
      [Parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
      [string] $ProjectName
   )
   process {
      $body = @{
         isEnabled  = $enabled.IsPresent;
         isBlocking = $blocking.IsPresent;
         type       = @{
            id = $type
         };
         settings   = $settings
      } | ConvertTo-Json -Depth 10 -Compress

      try {
         # Call the REST API
         $resp = _callAPI -Method Post -ProjectName $ProjectName `
            -Area policy `
            -Resource configurations `
            -Body $body `
            -Version $(_getApiVersion Policy)

         Write-Output $resp
      }
      catch {
         _handleException $_
      }
   }
}
