# Sets the permission inheritance to true or false.
# Get-VSTeamOption -area Contribution -resource HierarchyQuery
# id              : 3353e165-a11e-43aa-9d88-14f2bb09b6d9
# area            : Contribution
# resourceName    : HierarchyQuery
# routeTemplate   : _apis/{area}/{resource}/{scopeName}/{scopeValue}
# This is an undocumented API

function Set-VSTeamPermissionInheritance {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High',
    HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Set-VSTeamPermissionInheritance')]
   [OutputType([System.String])]
   param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ValueFromPipeline = $true)]
      [string] $Name,

      [Parameter(Mandatory = $true)]
      [ValidateSet('Repository', 'BuildDefinition', 'ReleaseDefinition')]
      [string] $ResourceType,

      [Parameter(Mandatory = $true)]
      [bool] $NewState,

      [switch] $Force,

      [Parameter(ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName
   )

   process {
      Write-Verbose "Creating VSTeamPermissionInheritance"
      $item = _getPermissionInheritanceInfo -projectName $ProjectName -resourceName $Name -resourceType $resourceType
      $token = $item.Token
      $projectID = $item.ProjectID
      $securityNamespaceID = $item.SecurityNamespaceID

      Write-Verbose "Token = $token"
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
         $resp = _callAPI -method POST -NoProject `
            -area Contribution `
            -resource HierarchyQuery `
            -id $projectID `
            -Body $body `
            -Version $(_getApiVersion HierarchyQuery)
      }

      Write-Verbose "Result: $(ConvertTo-Json -InputObject $resp -Depth 100)"

      if (($resp | Select-Object -ExpandProperty dataProviders | Select-Object -ExpandProperty 'ms.vss-admin-web.security-view-update-data-provider' | Select-Object -ExpandProperty statusCode) -eq "204") {
         return "Inheritance successfully changed for $ResourceType $Name."
      }
      else {
         Write-Error "Inheritance change failed for $ResourceType $Name."
      }
   }
}