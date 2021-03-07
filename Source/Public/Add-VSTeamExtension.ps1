# Install the specified extension into the account / project collection.
#
# Get-VSTeamOption 'extensionmanagement' 'installedextensionsbyname' -subDomain 'extmgmt'
# id              : fb0da285-f23e-4b56-8b53-3ef5f9f6de66
# area            : ExtensionManagement
# resourceName    : InstalledExtensionsByName
# routeTemplate   : _apis/{area}/{resource}/{publisherName}/{extensionName}/{version}
# http://bit.ly/Add-VSTeamExtension

function Add-VSTeamExtension {
   [CmdletBinding(HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Add-VSTeamExtension')]
   param(
      [parameter(Mandatory = $true)]
      [string] $PublisherId,

      [parameter(Mandatory = $true)]
      [string] $ExtensionId,

      [parameter(Mandatory = $false)]
      [string] $Version
   )
   Process {
      $id = "$PublisherId/$ExtensionId"

      if ($version) {
         $id += '/' + $Version
      }

      $resp = _callAPI -Method POST -SubDomain 'extmgmt' `
         -Area "extensionmanagement" `
         -Resource "installedextensionsbyname" `
         -Id $id `
         -Version $(_getApiVersion ExtensionsManagement)

      $item = [vsteam_lib.Extension]::new($resp)

      Write-Output $item
   }
}