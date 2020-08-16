function Add-VSTeamExtension {
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
         -Area extensionmanagement `
         -Resource installedextensionsbyname `
         -Id $id `
         -Version $(_getApiVersion ExtensionsManagement)

      $item = [vsteam_lib.Extension]::new($resp)

      Write-Output $item
   }
}