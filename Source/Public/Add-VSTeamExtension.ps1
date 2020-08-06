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

      $resp = _callAPI -Method Post -SubDomain 'extmgmt' `
         -Area extensionmanagement `
         -Resource installedextensionsbyname `
         -Id $id `
         -Version $(_getApiVersion ExtensionsManagement)

      $item = [VSTeamExtension]::new($resp)

      Write-Output $item
   }
}