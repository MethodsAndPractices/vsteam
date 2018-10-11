Set-StrictMode -Version Latest

# Load common code
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$here\common.ps1"

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
      $resource = 'extensionmanagement/installedextensionsbyname/' + $PublisherId + '/' + $ExtensionId 
      
      if ($version) {
         $resource += '/'+$Version
      }
       
      # Call the REST API
      _callAPI  -Method Post -SubDomain 'extmgmt' -Resource $resource -Version $([VSTeamVersions]::ExtensionsManagement) -ContentType "application/json"
   }  
}

function Get-VSTeamExtension {
   Process {
      #Call the REST API
      _callAPI  -Method Get -SubDomain 'extmgmt' -Resource 'extensionmanagement/installedextensions' -Version $([VSTeamVersions]::ExtensionsManagement) -ContentType "application/json"
   }
}

function Update-VSTeamExtension {
   param (
      [parameter(Mandatory = $true)]
      [string] $PublisherId,

      [parameter(Mandatory = $true)]
      [string] $ExtensionId,

      [parameter(Mandatory = $false)]
      [ValidateSet('none', 'disabled')]
      [string] $ExtensionState
   )

   $body =    @{
      extensionId    = $ExtensionId
      publisherId    = $PublisherId
      installState   = 
         {
            flags    = $ExtensionState
         }
  }
    
   # Call the REST API
   _callAPI  -Method Patch -Body $body -SubDomain 'extmgmt' -Resource 'extensionmanagement/installedextensions' -Version $([VSTeamVersions]::ExtensionsManagement) -ContentType "application/json"
}

function Remove-VSTeamExtension {
   param (
      [parameter(Mandatory = $true)]
      [string] $PublisherId,

      [parameter(Mandatory = $true)]
      [string] $ExtensionId
   )
   $resource = 'extensionmanagement/installedextensionsbyname/' + $PublisherId + '/' + $ExtensionId 
   # Call the REST API
   _callAPI  -Method Delete -SubDomain 'extmgmt' -Resource $resource -Version $([VSTeamVersions]::ExtensionsManagement) -ContentType "application/json"
}


Set-Alias Add-Extension Add-VSTeamExtension
Set-Alias Get-Extension Get-VSTeamExtension
Set-Alias Update-Extension Update-VSTeamExtension
Set-Alias Remove-Extension Remove-VSTeamExtension

Export-ModuleMember `
   -Function Add-VSTeamExtension, Get-VSTeamExtension, Update-VSTeamExtension, Remove-VSTeamExtension `
   -Alias Add-Extension, Get-Extension, Update-Extension, Remove-Extension