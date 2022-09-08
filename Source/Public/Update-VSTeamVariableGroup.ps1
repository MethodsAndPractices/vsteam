function Update-VSTeamVariableGroup {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Medium",
      HelpUri = 'https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Update-VSTeamVariableGroup')]
   param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $Id,

      [Parameter(ParameterSetName = 'ByHashtable', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $Name,

      [Parameter(ParameterSetName = 'ByHashtable', Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
      [string] $Description,

      [Parameter(ParameterSetName = 'ByHashtable', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [hashtable] $Variables,

      [Parameter(ParameterSetName = 'ByHashtable', Mandatory = $true)]
      [ValidateSet('Vsts', 'AzureKeyVault')]
      [string] $Type,

      [Parameter(ParameterSetName = 'ByHashtable', Mandatory = $false)]
      [hashtable] $ProviderData,

      [Parameter(ParameterSetName = 'ByBody', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $Body,

      [switch] $Force,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName
   )

   Process {
      if ([string]::IsNullOrWhiteSpace($Body)) {
         $bodyAsHashtable = @{
            name        = $Name
            description = $Description
            variables   = $Variables
            type        = $Type
         }

         if ($null -ne $ProviderData) {
            $bodyAsHashtable.Add("providerData", $ProviderData)
         }

         $body = $bodyAsHashtable | ConvertTo-Json -Depth 100
      }

      if ($Force -or $pscmdlet.ShouldProcess($Id, "Update Variable Group")) {
         # Call the REST API
         $resp = _callAPI -Method PUT -ProjectName $projectName `
            -Area distributedtask `
            -Resource variablegroups `
            -Id $Id `
            -body $body `
            -Version $(_getApiVersion VariableGroups)

         Write-Verbose $resp

         return Get-VSTeamVariableGroup -ProjectName $ProjectName -Id $Id
      }
   }
}
