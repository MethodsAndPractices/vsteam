function Get-VSTeamTaskGroup {
   [CmdletBinding(DefaultParameterSetName = 'List',
    HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Get-VSTeamTaskGroup')]
   param(
      [Parameter(ParameterSetName = 'ByID', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $Id,

      [Parameter(ParameterSetName = 'ByName', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $Name,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName
   )

   process {
      $commonArgs = @{
         Area        = 'distributedtask'
         Resource    = 'taskgroups'
         ProjectName = $ProjectName
         Version     = $(_getApiVersion TaskGroups)
      }

      if ($Id) {
         $resp = _callAPI @commonArgs -Id $Id

         _applyTypes -item $($resp.value) -type 'vsteam_lib.TaskGroup'

         Write-Output $resp.value
      }
      else {
         $resp = _callAPI @commonArgs

         if ($Name) {
            if ($resp.value) {
               foreach ($item in $resp.value) {
                  if ($item.PSObject.Properties.name -contains "name") {
                     if ($Name -eq $item.name) {
                        _applyTypes -item $item -type 'vsteam_lib.TaskGroup'

                        return $item
                     }
                  }
               }
            }
         }
         else {
            foreach ($item in $resp.value) {
               _applyTypes -item $item -type 'vsteam_lib.TaskGroup'

               Write-Output $item
            }
         }
      }
   }
}
