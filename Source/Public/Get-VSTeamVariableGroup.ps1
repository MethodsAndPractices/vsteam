function Get-VSTeamVariableGroup {
   [CmdletBinding(DefaultParameterSetName = 'List',
    HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Get-VSTeamVariableGroup')]
   param(
      [Parameter(Position = 0, ParameterSetName = 'ByID', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $Id,

      [Parameter(Position = 0, ParameterSetName = 'ByName', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $Name,

      [Parameter(Position = 1, ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter]) ]
      [string] $ProjectName
   )

   process {
      $commonArgs = @{
         ProjectName = $ProjectName
         Area        = 'distributedtask'
         Resource    = 'variablegroups'
         Version     = $(_getApiVersion VariableGroups)
      }

      if ($Id) {
         # Call the REST API
         $resp = _callAPI @commonArgs -Id $Id

         _applyTypesToVariableGroup -item $resp

         Write-Output $resp
      }
      else {
         if ($Name) {
            $resp = _callAPI @commonArgs -QueryString @{groupName = $Name }

            _applyTypesToVariableGroup -item $resp.value

            Write-Output $resp.value
         }
         else {
            # Call the REST API
            $resp = _callAPI @commonArgs

            # Apply a Type Name so we can use custom format view and custom type extensions
            foreach ($item in $resp.value) {
               _applyTypesToVariableGroup -item $item
            }

            return $resp.value
         }
      }
   }
}