function Get-VSTeamPermissionInheritance {
   [OutputType([System.String])]
   [CmdletBinding()]
   param(
      [Parameter(Mandatory, ValueFromPipelineByPropertyName = $true, ValueFromPipeline = $true)]
      [string] $Name,

      [Parameter(Mandatory)]
      [ValidateSet('Repository', 'BuildDefinition', 'ReleaseDefinition')]
      [string] $resourceType
   )

   DynamicParam {
      _buildProjectNameDynamicParam -mandatory $true
   }

   process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]
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
         $resp = (Get-VSTeamAccessControlList -SecurityNamespaceId $securityNamespaceID -token $token | Select-Object -ExpandProperty InheritPermissions)
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
         $resp = (_callAPI -method POST -area "Contribution" -resource "HierarchyQuery/project" -id $projectID -Version $version -ContentType "application/json" -Body $body |
            Select-Object -ExpandProperty dataProviders |
            Select-Object -ExpandProperty 'ms.vss-admin-web.security-view-data-provider' |
            Select-Object -ExpandProperty permissionsContextJson |
            ConvertFrom-Json |
            Select-Object -ExpandProperty inheritPermissions)
      }

      Switch ($resp) {
         { ($resp -eq $true) -or ($resp -eq $false) } {
            return $resp
         }

         { ($resp -ne $true) -and ($resp -ne $false) } {
            Write-Error "Unable to retrieve permission inheritance state."
            return
         }
      }
   }
}
