# Returns true or false.
# Get-VSTeamOption -area Contribution -resource HierarchyQuery
# id              : 3353e165-a11e-43aa-9d88-14f2bb09b6d9
# area            : Contribution
# resourceName    : HierarchyQuery
# routeTemplate   : _apis/{area}/{resource}/{scopeName}/{scopeValue}
# This is an undocumented API

function Get-VSTeamPermissionInheritance {
   [OutputType([System.String])]
   [CmdletBinding()]
   param(
      [Parameter(Mandatory, ValueFromPipelineByPropertyName = $true, ValueFromPipeline = $true)]
      [string] $Name,

      [Parameter(Mandatory, ValueFromPipelineByPropertyName = $true)]
      [ValidateSet('Repository', 'BuildDefinition', 'ReleaseDefinition')]
      [string] $resourceType,

      [Parameter(ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName
   )

   process {
      # This will throw if this account does not support the HierarchyQuery API
      _supportsHierarchyQuery

      Write-Verbose "Creating VSTeamPermissionInheritance"
      $item = _getPermissionInheritanceInfo -projectName $ProjectName -resourceName $Name -resourceType $resourceType
      $token = $item.Token
      $projectID = $item.ProjectID
      $securityNamespaceID = $item.SecurityNamespaceID

      Write-Verbose "Token = $token"
      Write-Verbose "Version = $Version"
      Write-Verbose "ProjectID = $ProjectID"
      Write-Verbose "SecurityNamespaceID = $SecurityNamespaceID"

      if ($resourceType -eq "Repository") {
         Write-Output (Get-VSTeamAccessControlList -SecurityNamespaceId $securityNamespaceID -token $token | Select-Object -ExpandProperty InheritPermissions)
      }
      else {
         $body = @"
{
    "contributionIds":["ms.vss-admin-web.security-view-data-provider"],
    "dataProviderContext":
    {
        "properties":
        {
            "permissionSetId":"$securityNamespaceID",
            "permissionSetToken":"$token",
        }
    }
}
"@

         $resp = _callAPI -method POST `
            -area Contribution `
            -resource HierarchyQuery `
            -id "project/$projectID" `
            -Body $body `
            -Version $(_getApiVersion HierarchyQuery)

         Write-Verbose $($resp | ConvertTo-Json -Depth 99)

         Write-Output ($resp |
            Select-Object -ExpandProperty dataProviders |
            Select-Object -ExpandProperty 'ms.vss-admin-web.security-view-data-provider' |
            Select-Object -ExpandProperty permissionsContextJson |
            ConvertFrom-Json |
            Select-Object -ExpandProperty inheritPermissions)
      }
   }
}