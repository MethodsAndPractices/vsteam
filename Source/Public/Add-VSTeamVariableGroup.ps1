# Adds a variable group.
#
# Get-VSTeamOption 'distributedtask' 'variablegroups'
# id              : f5b09dd5-9d54-45a1-8b5a-1c8287d634cc
# area            : distributedtask
# resourceName    : variablegroups
# routeTemplate   : {project}/_apis/{area}/{resource}/{groupId}
# http://bit.ly/Add-VSTeamVariableGroup

function Add-VSTeamVariableGroup {
   [CmdletBinding(HelpUri = 'https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Add-VSTeamVariableGroup')]
   param(
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

      [Parameter(ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName
   )

   Process {
      # This will throw if this account does not support the variable groups
      _supportVariableGroups

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

      # Call the REST API
      $resp = _callAPI -Method POST -ProjectName $projectName `
         -Area "distributedtask" `
         -Resource "variablegroups" `
         -body $body `
         -Version $(_getApiVersion VariableGroups)

      return Get-VSTeamVariableGroup -ProjectName $ProjectName -id $resp.id
   }
}