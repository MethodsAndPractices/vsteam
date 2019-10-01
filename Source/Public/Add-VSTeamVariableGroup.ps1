# function Add-VSTeamVariableGroup {
#    param(
#       [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
#       [string] $Name,

#       [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
#       [string] $Description,

#       [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
#       [hashtable] $Variables
#    )

#    DynamicParam {
#       $dp = _buildProjectNameDynamicParam

#       if ([VSTeamVersions]::Version -ne "TFS2017") {
#          $ParameterName = 'Type'
#          $rp = _buildDynamicParam -ParameterName $ParameterName -arrSet ('Vsts', 'AzureKeyVault') -Mandatory $true
#          $dp.Add($ParameterName, $rp)

#          $ParameterName = 'ProviderData'
#          $rp = _buildDynamicParam -ParameterName $ParameterName -Mandatory $false -ParameterType ([hashtable])
#          $dp.Add($ParameterName, $rp)
#       }

#       return $dp
#    }

#    Process {
#       # Bind the parameter to a friendly variable
#       $ProjectName = $PSBoundParameters["ProjectName"]

#       $body = @{
#          name        = $Name
#          description = $Description
#          variables   = $Variables
#       }
#       if ([VSTeamVersions]::Version -ne "TFS2017") {
#          $Type = $PSBoundParameters['Type']
#          $body.Add("type", $Type)

#          $ProviderData = $PSBoundParameters['ProviderData']
#          if ($null -ne $ProviderData) {
#             $body.Add("providerData", $ProviderData)
#          }
#       }

#       $body = $body | ConvertTo-Json

#       # Call the REST API
#       $resp = _callAPI -ProjectName $projectName -Area 'distributedtask' -Resource 'variablegroups'  `
#          -Method Post -ContentType 'application/json' -body $body -Version $([VSTeamVersions]::VariableGroups)

#       return Get-VSTeamVariableGroup -ProjectName $ProjectName -id $resp.id
#    }
# }

function Add-VSTeamVariableGroup {
   [CmdletBinding()]
   param(
      [string] $Body
   )

   DynamicParam {
      _buildProjectNameDynamicParam
   }

   process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      $resp = _callAPI -Method Post -ProjectName $ProjectName -Area distributedTask -Resource VariableGroups -Version $([VSTeamVersions]::DistributedTask) -Body $Body -ContentType 'application/json'

      return $resp
   }
}