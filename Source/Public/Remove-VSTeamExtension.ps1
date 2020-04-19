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
      $resource = "extensionmanagement/installedextensionsbyname/$PublisherId/$ExtensionId"

      $resp = _callAPI -NoProject -Method Delete -SubDomain 'extmgmt' -Resource $resource -Version $(_getApiVersion ExtensionsManagement)

      Write-Output $resp
   }
}