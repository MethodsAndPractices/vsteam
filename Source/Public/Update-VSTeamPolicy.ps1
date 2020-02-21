function Update-VSTeamPolicy {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Medium")]
   param(
      [Parameter(Mandatory = $true)]
      [int] $id,

      [Parameter(Mandatory = $false)]
      [guid] $type,

      [switch] $enabled,

      [switch] $blocking,

      [Parameter(Mandatory = $true)]
      [hashtable] $settings,

      [switch] $Force
   )

   DynamicParam {
      _buildProjectNameDynamicParam -mandatory $true
   }

   process {
      $ProjectName = $PSBoundParameters["ProjectName"]

      if (-not $type) {
         $policy = Get-VSTeamPolicy -ProjectName $ProjectName -Id $id | Select-Object -First 1
         $type = $policy.type.id
      }

      $body = @{
         isEnabled  = $enabled.IsPresent;
         isBlocking = $blocking.IsPresent;
         type       = @{
            id = $type
         }
         settings   = $settings
      } | ConvertTo-Json -Depth 10 -Compress

      try {
         if ($Force -or $pscmdlet.ShouldProcess($id, "Update Policy")) {
            # Call the REST API
            $resp = _callAPI -ProjectName $ProjectName -Area 'policy' -id $id -Resource 'configurations' `
               -Method Put -ContentType 'application/json' -Body $body -Version $([VSTeamVersions]::Git)

            Write-Output $resp
         }
      }
      catch {
         _handleException $_
      }
   }
}