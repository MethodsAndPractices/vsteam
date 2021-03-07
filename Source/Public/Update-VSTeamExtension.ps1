function Update-VSTeamExtension {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Medium",
    HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Update-VSTeamExtension')]
   param (
      [parameter(Mandatory = $true)]
      [string] $PublisherId,

      [parameter(Mandatory = $true)]
      [string] $ExtensionId,

      [parameter(Mandatory = $true)]
      [ValidateSet('none', 'disabled')]
      [string] $ExtensionState,

      [switch] $Force
   )
   if ($Force -or $pscmdlet.ShouldProcess($ExtensionId, "Update extension")) {

      $obj = @{
         extensionId  = $ExtensionId
         publisherId  = $PublisherId
         installState = @{
            flags = $ExtensionState
         }
      }

      $body = $obj | ConvertTo-Json

      $resp = _callAPI -Method PATCH -SubDomain extmgmt `
         -Area extensionmanagement `
         -Resource installedextensions `
         -Body $body `
         -Version $(_getApiVersion ExtensionsManagement)

      $item = [vsteam_lib.Extension]::new($resp)

      Write-Output $item
   }
}