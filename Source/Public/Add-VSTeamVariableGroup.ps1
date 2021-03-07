# Adds a variable group.
#
# Get-VSTeamOption 'distributedtask' 'variablegroups'
# id              : f5b09dd5-9d54-45a1-8b5a-1c8287d634cc
# area            : distributedtask
# resourceName    : variablegroups
# routeTemplate   : {project}/_apis/{area}/{resource}/{groupId}
# http://bit.ly/Add-VSTeamVariableGroup

function Add-VSTeamVariableGroup {
   [CmdletBinding(HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Add-VSTeamVariableGroup')]
   param(
      [Parameter(ParameterSetName = 'ByHashtable', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $Name,

      [Parameter(ParameterSetName = 'ByHashtable', Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
      [string] $Description,

      [Parameter(ParameterSetName = 'ByHashtable', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [hashtable] $Variables,

      [Parameter(ParameterSetName = 'ByBody', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $Body,

      [Parameter(ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName
   )
   DynamicParam {
      $dp = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary

      if ([vsteam_lib.Versions]::Version -ne "TFS2017" -and $PSCmdlet.ParameterSetName -eq "ByHashtable") {
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
      # This will throw if this account does not support the variable groups
      _supportVariableGroups

      if ([string]::IsNullOrWhiteSpace($Body)) {
         $bodyAsHashtable = @{
            name        = $Name
            description = $Description
            variables   = $Variables
         }
         if ([vsteam_lib.Versions]::Version -ne "TFS2017") {
            $Type = $PSBoundParameters['Type']
            $bodyAsHashtable.Add("type", $Type)

            $ProviderData = $PSBoundParameters['ProviderData']
            if ($null -ne $ProviderData) {
               $bodyAsHashtable.Add("providerData", $ProviderData)
            }
         }

         $body = $bodyAsHashtable | ConvertTo-Json
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