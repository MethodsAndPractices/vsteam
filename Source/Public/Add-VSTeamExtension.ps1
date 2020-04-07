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
      $resource = "extensionmanagement/installedextensionsbyname/$PublisherId/$ExtensionId"

      if ($version) {
         $resource += '/' + $Version
      }

      $resp = _callAPI -Method Post -SubDomain 'extmgmt' -Resource $resource -Version $(_getApiVersion ExtensionsManagement) -ContentType "application/json"

      $item = [VSTeamExtension]::new($resp)

      Write-Output $item
   }
}