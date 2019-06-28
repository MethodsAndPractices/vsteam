function Add-VSTeamVariableGroup {
   param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $variableGroupName,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [ValidateSet('Vsts', 'AzureKeyVault')]
      [string] $variableGroupType,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $variableGroupDescription,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [hashtable] $variableGroupVariables,

      [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
      [hashtable] $variableGroupProviderData = $null
   )

   DynamicParam {
      _buildProjectNameDynamicParam
   }

   Process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      $body = @{
         name        = $variableGroupName
         type        = $variableGroupType
         description = $variableGroupDescription
         variables   = $variableGroupVariables
      }
      if ($null -ne $variableGroupProviderData) {
         $body.Add("providerData", $variableGroupProviderData)
      }

      $body = $body | ConvertTo-Json

      # Call the REST API
      $resp = _callAPI -ProjectName $projectName -Area 'distributedtask' -Resource 'variablegroups'  `
         -Method Post -ContentType 'application/json' -body $body -Version $([VSTeamVersions]::VariableGroups)

      return Get-VSTeamVariableGroup -ProjectName $ProjectName -id $resp.id
   }
}
