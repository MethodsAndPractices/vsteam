function Get-VSTeamVariableGroup {
   [CmdletBinding(DefaultParameterSetName = 'List')]
   param(
      [Parameter(Position = 0, ParameterSetName = 'ByID', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $Id,

      [Parameter(Position = 0, ParameterSetName = 'ByName', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $Name
   )

   DynamicParam {
      _buildProjectNameDynamicParam -Position 1
   }

   Process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      if ($Id) {
         # Call the REST API
         $resp = _callAPI -ProjectName $ProjectName -Area 'distributedtask' -Resource 'variablegroups'  `
            -Version $(_getApiVersion VariableGroups) -Id $Id

         _applyTypesToVariableGroup -item $resp

         Write-Output $resp
      }
      else {
         if ($Name) {
            $resp = _callAPI -ProjectName $ProjectName -Area 'distributedtask' -Resource 'variablegroups' -Version $(_getApiVersion VariableGroups) -Method Get `
               -QueryString @{groupName = $Name }

            _applyTypesToVariableGroup -item $resp.value

            Write-Output $resp.value
         }
         else {
            # Call the REST API
            $resp = _callAPI -ProjectName $ProjectName -Area 'distributedtask' -Resource 'variablegroups'  `
               -Version $(_getApiVersion VariableGroups)

            # Apply a Type Name so we can use custom format view and custom type extensions
            foreach ($item in $resp.value) {
               _applyTypesToVariableGroup -item $item
            }

            return $resp.value
         }
      }
   }
}
