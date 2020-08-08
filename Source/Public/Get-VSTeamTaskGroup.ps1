function Get-VSTeamTaskGroup {
   [CmdletBinding(DefaultParameterSetName = 'List')]
   param(
      [Parameter(ParameterSetName = 'ByID', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $Id,

      [Parameter(ParameterSetName = 'ByName', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $Name,

      [Parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
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

         Write-Output $resp.value
      }
      else {
         $resp = _callAPI @commonArgs
         
         if ($Name) {
            if ($resp.value) {
               foreach ($item in $resp.value) {
                  if ($item.PSObject.Properties.name -contains "name") {
                     if ($Name -eq $item.name) {
                        return $item
                     }
                  }
               }
               return $null
            }
            else {
               return $null
            }
         }
         else {
            foreach ($item in $resp.value) {
               Write-Output $item
            }
         }
      }
   }
}
