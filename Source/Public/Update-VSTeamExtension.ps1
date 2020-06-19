function Update-VSTeamExtension {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Medium")]
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

      $resp = _callAPI -Method Patch -body $body -SubDomain 'extmgmt' -Area 'extensionmanagement' -Resource 'installedextensions' -Version $(_getApiVersion ExtensionsManagement) -ContentType "application/json"

      $item = [VSTeamExtension]::new($resp)

      Write-Output $item
   }
}