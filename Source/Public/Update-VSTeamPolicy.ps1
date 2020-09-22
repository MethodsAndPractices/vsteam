function Update-VSTeamPolicy {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Medium",
    HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Update-VSTeamPolicy')]
   param(
      [Parameter(Mandatory = $true)]
      [int] $id,

      [Parameter(Mandatory = $false)]
      [guid] $type,

      [switch] $enabled,

      [switch] $blocking,

      [Parameter(Mandatory = $true)]
      [hashtable] $settings,

      [switch] $Force,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName
   )

   process {
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
            $resp = _callAPI -Method PUT -ProjectName $ProjectName `
               -Area policy `
               -Resource configurations `
               -id $id `
               -Body $body `
               -Version $(_getApiVersion Policy)

            Write-Output $resp
         }
      }
      catch {
         _handleException $_
      }
   }
}
