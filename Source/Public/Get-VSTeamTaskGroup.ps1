
function Get-VSTeamTaskGroup {
   [CmdletBinding(DefaultParameterSetName = 'List')]
   param(
      [Parameter(ParameterSetName = 'ByID', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
     [string] $Id,
     
     [Parameter(ParameterSetName = 'ByName', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
     [string] $Name
  )

  DynamicParam {
     _buildProjectNameDynamicParam
  }

  process {
     # Bind the parameter to a friendly variable
     $ProjectName = $PSBoundParameters["ProjectName"]

     if ($Id) {
        $resp = _callAPI -ProjectName $ProjectName -Area distributedtask -Resource taskgroups -Version $([VSTeamVersions]::TaskGroups) -Id $Id -Method Get

        Write-Output $resp.value
     }
     else {
         $resp = _callAPI -ProjectName $ProjectName -Area distributedtask -Resource taskgroups -Version $([VSTeamVersions]::TaskGroups) -Method Get
                 
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