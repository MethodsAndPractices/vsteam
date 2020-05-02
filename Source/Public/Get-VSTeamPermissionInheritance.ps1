function Get-VSTeamPermissionInheritance {
   [OutputType([System.String])]
   [CmdletBinding()]
   param(
      [Parameter(Mandatory, ValueFromPipelineByPropertyName = $true, ValueFromPipeline = $true)]
      [string] $Name,

      [Parameter(Mandatory)]
      [ValidateSet('Repository', 'BuildDefinition', 'ReleaseDefinition')]
      [string] $resourceType,

      [Parameter(Position = 0, ValueFromPipelineByPropertyName = $true)]
      [ProjectValidateAttribute()]
      [ArgumentCompleter([ProjectCompleter])]
      [string] $ProjectName
   )

   process {
      Write-Verbose "Creating VSTeamPermissionInheritance"
      $item = [VSTeamPermissionInheritance]::new($ProjectName, $Name, $resourceType)
      $token = $item.Token
      $version = $item.Version
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

         $resp = _callAPI -method POST -area "Contribution" -resource "HierarchyQuery/project" -id $projectID -Version $version -ContentType "application/json" -Body $body

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