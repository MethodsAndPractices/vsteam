function Set-VSTeamPermissionInheritance {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
   [OutputType([System.String])]
   param(
      [Parameter(Mandatory)]
      [string] $resourceName,

      [Parameter(Mandatory)]
      [ValidateSet('Repository', 'BuildDefinition', 'ReleaseDefinition')]
      [string] $resourceType,

      [Parameter(Mandatory)]
      [bool] $newState,

      # Forces the command without confirmation
      [switch] $Force
   )

   DynamicParam {
      _buildProjectNameDynamicParam -mandatory $true
   }

   process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]
      Write-Verbose "Creating VSTeamPermissionInheritance"
      $item = [VSTeamPermissionInheritance]::new($ProjectName, $resourceName, $resourceType)
      $token = $item.Token
      $version = $item.Version
      $projectID = $item.ProjectID
      $securityNamespaceID = $item.SecurityNamespaceID

      Write-Verbose "Token = $token"
      Write-Verbose "Version = $Version"
      Write-Verbose "ProjectID = $ProjectID"
      Write-Verbose "SecurityNamespaceID = $SecurityNamespaceID"

      if ($force -or $PSCmdlet.ShouldProcess($resourceName, "Set Permission Inheritance")) {
         $body = @"
{
    "contributionIds":["ms.vss-admin-web.security-view-update-data-provider"],
    "dataProviderContext":
    {
        "properties":
        {
            "changeInheritance":true,
            "permissionSetId":"$securityNamespaceID",
            "permissionSetToken":"$token",
            "inheritPermissions":$newState
        }
    }
}
"@
         # Call the REST API to change the inheritance state
         $resp = _callAPI -method POST -area "Contribution" -resource "HierarchyQuery" -id $projectID -Version $version -ContentType "application/json" -Body $body
      }

      if (($resp | Select-Object -ExpandProperty dataProviders | Select-Object -ExpandProperty 'ms.vss-admin-web.security-view-update-data-provider' | Select-Object -ExpandProperty statusCode) -eq "204") {
         Return "Inheritance successfully changed for $resourceType $resourceName."
      }
      else {
         Write-Error "Inheritance change failed for $resourceType $resourceName."
         Return
      }
   }
}