function Set-VSTeamPermissionInheritance {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
   [OutputType([System.String])]
   param(
      [Parameter(Mandatory, ValueFromPipelineByPropertyName = $true, ValueFromPipeline = $true)]
      [string] $Name,

      [Parameter(Mandatory)]
      [ValidateSet('Repository', 'BuildDefinition', 'ReleaseDefinition')]
      [string] $ResourceType,

      [Parameter(Mandatory)]
      [bool] $NewState,

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
      $item = [VSTeamPermissionInheritance]::new($ProjectName, $Name, $ResourceType)
      $token = $item.Token
      $version = $item.Version
      $projectID = $item.ProjectID
      $securityNamespaceID = $item.SecurityNamespaceID

      Write-Verbose "Token = $token"
      Write-Verbose "Version = $Version"
      Write-Verbose "ProjectID = $ProjectID"
      Write-Verbose "SecurityNamespaceID = $SecurityNamespaceID"

      if ($force -or $PSCmdlet.ShouldProcess($Name, "Set Permission Inheritance")) {
         # The case of the state is important. It must be lowercase.
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
            "inheritPermissions":$($NewState.ToString().ToLower())
        }
    }
}
"@
         # Call the REST API to change the inheritance state
         $resp = _callAPI -method POST -area "Contribution" -resource "HierarchyQuery" -id $projectID -Version $version -ContentType "application/json;charset=utf-8" -Body $body
      }

      Write-Verbose "Result: $(ConvertTo-Json -InputObject $resp -Depth 100)"

      if (($resp | Select-Object -ExpandProperty dataProviders | Select-Object -ExpandProperty 'ms.vss-admin-web.security-view-update-data-provider' | Select-Object -ExpandProperty statusCode) -eq "204") {
         Return "Inheritance successfully changed for $ResourceType $Name."
      }
      else {
         Write-Error "Inheritance change failed for $ResourceType $Name."
         Return
      }
   }
}