function Remove-VSTeamExtension {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
   param (
      [parameter(Mandatory = $true)]
      [string] $PublisherId,

      [parameter(Mandatory = $true)]
      [string] $ExtensionId,

      [switch] $Force
   )

   if ($Force -or $pscmdlet.ShouldProcess($ExtensionId, "Remove extension")) {
      $id = "$PublisherId/$ExtensionId"

      $resp = _callAPI -Method Delete -NoProject -SubDomain extmgmt `
         -Area extensionmanagement `
         -Resource installedextensionsbyname `
         -Id $id `
         -Version $(_getApiVersion ExtensionsManagement)

      Write-Output $resp
   }
}