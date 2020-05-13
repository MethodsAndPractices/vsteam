function Update-VSTeamVariableGroup {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Medium")]
   param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $Id,

      [Parameter(ParameterSetName = 'ByHashtable', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $Name,

      [Parameter(ParameterSetName = 'ByHashtable', Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
      [string] $Description,

      [Parameter(ParameterSetName = 'ByHashtable', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [hashtable] $Variables,

      [Parameter(ParameterSetName = 'ByBody', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $Body,

      [switch] $Force,

      [ProjectValidateAttribute()]
      [ArgumentCompleter([ProjectCompleter])]
      [Parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
      [string] $ProjectName
   )

   DynamicParam {
      $dp = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary

      if ($(_getApiVersion -Target) -ne "TFS2017" -and $PSCmdlet.ParameterSetName -eq "ByHashtable") {
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
      if ([string]::IsNullOrWhiteSpace($Body)) {
         $bodyAsHashtable = @{
            name        = $Name
            description = $Description
            variables   = $Variables
         }

         if ([VSTeamVersions]::Version -ne "TFS2017") {
            $Type = $PSBoundParameters['Type']
            $bodyAsHashtable.Add("type", $Type)

            $ProviderData = $PSBoundParameters['ProviderData']
            if ($null -ne $ProviderData) {
               $bodyAsHashtable.Add("providerData", $ProviderData)
            }
         }

         $body = $bodyAsHashtable | ConvertTo-Json
      }

      if ($Force -or $pscmdlet.ShouldProcess($Id, "Update Variable Group")) {
         # Call the REST API
         $resp = _callAPI -ProjectName $projectName -Area 'distributedtask' -Resource 'variablegroups' -Id $Id  `
            -Method Put -ContentType 'application/json' -body $body -Version $(_getApiVersion VariableGroups)

         Write-Verbose $resp

         return Get-VSTeamVariableGroup -ProjectName $ProjectName -Id $Id
      }
   }
}
