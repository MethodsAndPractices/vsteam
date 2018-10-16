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
      $resource = "extensionmanagement/installedextensionsbyname/$PublisherId/$ExtensionId"
      
      if ($version) {
         $resource += '/' + $Version
      }
       
      $resp = _callAPI -Method Post -SubDomain 'extmgmt' -Resource $resource -Version $([VSTeamVersions]::ExtensionsManagement) -ContentType "application/json"
         
      $item = [VSTeamExtension]::new($resp)

      Write-Output $item         
   }  
}

function Get-VSTeamExtension {
   param (
      [Parameter(ParameterSetName = 'List', Mandatory = $false)]
      [switch] $IncludeInstallationIssues,

      [Parameter(ParameterSetName = 'List', Mandatory = $false)]
      [switch] $IncludeDisabledExtensions,

      [Parameter(ParameterSetName = 'List', Mandatory = $false)]
      [switch] $IncludeErrors,

      [Parameter(ParameterSetName = 'GetById', Mandatory = $true)]
      [string] $PublisherId,

      [Parameter(ParameterSetName = 'GetById', Mandatory = $true)]
      [string] $ExtensionId      
   )
   Process {

      if ($PublisherId -and $ExtensionId) {
         $resource = "extensionmanagement/installedextensionsbyname/$PublisherId/$ExtensionId"
         
         $resp = _callAPI -SubDomain 'extmgmt' -Resource $resource -Version $([VSTeamVersions]::ExtensionsManagement)
         
         $item = [VSTeamExtension]::new($resp)

         Write-Output $item
      }
      else {
         $queryString = @{}
         if ($IncludeInstallationIssues.IsPresent) {
            $queryString.includeCapabilities = $true
         }
         
         if ($IncludeDisabledExtensions.IsPresent) {
            $queryString.includeDisabledExtensions = $true
         }

         if ($IncludeErrors.IsPresent) {
            $queryString.includeErrors = $true
         }
         
         $resp = _callAPI -SubDomain 'extmgmt' -Resource 'extensionmanagement/installedextensions' -QueryString $queryString -Version $([VSTeamVersions]::ExtensionsManagement)

         $objs = @()

         foreach ($item in $resp.value) {
            $objs += [VSTeamExtension]::new($item)
         }
   
         Write-Output $objs
      }
   }
}

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
      
      $resp = _callAPI -Method Patch -body $body -SubDomain 'extmgmt' -Resource 'extensionmanagement/installedextensions' -Version $([VSTeamVersions]::ExtensionsManagement) -ContentType "application/json"
         
      $item = [VSTeamExtension]::new($resp)

      Write-Output $item
   }
}

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

      $resp = _callAPI -Method Delete -SubDomain 'extmgmt' -Resource $resource -Version $([VSTeamVersions]::ExtensionsManagement)
      
      Write-Output $resp 
   }
}

Set-Alias Add-Extension Add-VSTeamExtension
Set-Alias Get-Extension Get-VSTeamExtension
Set-Alias Update-Extension Update-VSTeamExtension
Set-Alias Remove-Extension Remove-VSTeamExtension

Export-ModuleMember `
   -Function Add-VSTeamExtension, Get-VSTeamExtension, Update-VSTeamExtension, Remove-VSTeamExtension `
   -Alias Add-Extension, Get-Extension, Update-Extension, Remove-Extension