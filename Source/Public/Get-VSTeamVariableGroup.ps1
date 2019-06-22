function Get-VSTeamVariableGroup {
   [CmdletBinding(DefaultParameterSetName = 'List')]
   param(
      [Parameter(Position = 0, ParameterSetName = 'ByID', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $id
   )

   DynamicParam {
      _buildProjectNameDynamicParam -Position 1
   }

   Process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      if ($id) {
         # Call the REST API
         $resp = _callAPI -ProjectName $ProjectName -Area 'distributedtask' -Resource 'variablegroups'  `
            -Version $([VSTeamVersions]::DistributedTask) -Id $id

         _applyTypesToVariableGroup -item $resp

         Write-Output $resp
      } else {
         # Call the REST API
         $resp = _callAPI -ProjectName $ProjectName -Area 'distributedtask' -Resource 'variablegroups'  `
            -Version $([VSTeamVersions]::VariableGroups)

         # Apply a Type Name so we can use custom format view and custom type extensions
         foreach ($item in $resp.value) {
            _applyTypesToVariableGroup -item $item
         }

         return $resp.value
      }
   }
}