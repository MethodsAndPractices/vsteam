function Add-VSTeamPolicy {
   [CmdletBinding()]
   param(
      [Parameter(Mandatory = $true)]
      [guid] $type,

      [switch] $enabled,

      [switch] $blocking,

      [Parameter(Mandatory = $true)]
      [hashtable] $settings
   )

   DynamicParam {
      _buildProjectNameDynamicParam -mandatory $true
   }

   process {
      $ProjectName = $PSBoundParameters["ProjectName"]

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
         $resp = _callAPI -ProjectName $ProjectName -Area 'policy' -Resource 'configurations' `
            -Method Post -ContentType 'application/json' -Body $body -Version $([VSTeamVersions]::Git)

         Write-Output $resp
      }
      catch {
         _handleException $_
      }
   }
}