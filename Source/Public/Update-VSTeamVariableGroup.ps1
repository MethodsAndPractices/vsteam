function Update-VSTeamVariableGroup {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Medium")]
   param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $id,

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
      [hashtable] $variableGroupProviderData = $null,

      [switch] $Force
   )

   DynamicParam {
      _buildProjectNameDynamicParam
   }

   Process {
      # This will throw if this account does not support Variable Groups
      _supportsVariableGroups

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

      if ($Force -or $pscmdlet.ShouldProcess($id, "Update Variable Group")) {
         # Call the REST API
         $resp = _callAPI -ProjectName $projectName -Area 'distributedtask' -Resource 'variablegroups' -Id $id  `
            -Method Put -ContentType 'application/json' -body $body -Version $([VSTeamVersions]::VariableGroups)

         Write-Verbose $resp

         return Get-VSTeamVariableGroup -ProjectName $ProjectName -id $id
      }
   }
}