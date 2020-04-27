function Get-VSTeamTaskGroup {
   [CmdletBinding(DefaultParameterSetName = 'List')]
   param(
      [Parameter(ParameterSetName = 'ByID', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $Id,

      [Parameter(ParameterSetName = 'ByName', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $Name,

      [Parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
      [ProjectValidateAttribute()]
      [ArgumentCompleter([ProjectCompleter])]
      [string] $ProjectName
   )

   process {
      if ($Id) {
         $resp = _callAPI -ProjectName $ProjectName -Area distributedtask -Resource taskgroups -Version $(_getApiVersion TaskGroups) -Id $Id -Method Get

         Write-Output $resp.value
      }
      else {
         $resp = _callAPI -ProjectName $ProjectName -Area distributedtask -Resource taskgroups -Version $(_getApiVersion TaskGroups) -Method Get
         
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
