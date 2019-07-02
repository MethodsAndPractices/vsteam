function Update-VSTeamVariableGroup {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Medium")]
   param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $Id,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $Name,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $Description,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [hashtable] $Variables,

      [switch] $Force
   )

   DynamicParam {
      $dp = _buildProjectNameDynamicParam

      if ([VSTeamVersions]::Version -ne "TFS2017") {
         $ParameterName = 'Type'
         $rp = _buildDynamicParam -ParameterName $ParameterName -arrSet ('Vsts', 'AzureKeyVault') -Mandatory $true
         $dp.Add($ParameterName, $rp)

         $ParameterName = 'ProviderData'
         $rp = _buildDynamicParam -ParameterName $ParameterName -Mandatory $false -ParameterType ([hashtable])
         $dp.Add($ParameterName, $rp)
      }

      return $dp
   }

   Process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      $body = @{
         name        = $Name
         description = $Description
         variables   = $Variables
      }
      if ([VSTeamVersions]::Version -ne "TFS2017") {
         $Type = $PSBoundParameters['Type']
         $body.Add("type", $Type)

         $ProviderData = $PSBoundParameters['ProviderData']
         if ($null -ne $ProviderData) {
            $body.Add("providerData", $ProviderData)
         }
      }

      $body = $body | ConvertTo-Json

      if ($Force -or $pscmdlet.ShouldProcess($Id, "Update Variable Group")) {
         # Call the REST API
         $resp = _callAPI -ProjectName $projectName -Area 'distributedtask' -Resource 'variablegroups' -Id $Id  `
            -Method Put -ContentType 'application/json' -body $body -Version $([VSTeamVersions]::VariableGroups)

         Write-Verbose $resp

         return Get-VSTeamVariableGroup -ProjectName $ProjectName -Id $Id
      }
   }
}
