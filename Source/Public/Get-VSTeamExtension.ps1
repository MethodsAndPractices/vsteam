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
         $id = "$PublisherId/$ExtensionId"

         $resp = _callAPI -SubDomain 'extmgmt' `
            -Area 'extensionmanagement' `
            -Resource 'installedextensionsbyname' `
            -Id $id `
            -Version $(_getApiVersion ExtensionsManagement)

         $item = [VSTeamExtension]::new($resp)

         Write-Output $item
      }
      else {
         $queryString = @{ }
         if ($IncludeInstallationIssues.IsPresent) {
            $queryString.includeCapabilities = $true
         }

         if ($IncludeDisabledExtensions.IsPresent) {
            $queryString.includeDisabledExtensions = $true
         }

         if ($IncludeErrors.IsPresent) {
            $queryString.includeErrors = $true
         }

         $resp = _callAPI -SubDomain 'extmgmt' `
            -Area 'extensionmanagement' `
            -Resource 'installedextensions' `
            -QueryString $queryString `
            -Version $(_getApiVersion ExtensionsManagement)

         $objs = @()

         foreach ($item in $resp.value) {
            $objs += [VSTeamExtension]::new($item)
         }

         Write-Output $objs
      }
   }
}