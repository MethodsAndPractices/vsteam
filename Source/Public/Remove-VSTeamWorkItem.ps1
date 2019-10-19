function Remove-VSTeamWorkItem {
   [CmdletBinding(DefaultParameterSetName = 'ByID')]
   param(
      [Parameter(ParameterSetName = 'ByID', Mandatory = $true, ValueFromPipeline = $true, Position = 0)]
      [int] $Id,

      [Parameter(ParameterSetName = 'List', Mandatory = $true, ValueFromPipeline = $true, Position = 0)]
      [int[]] $Ids,

      [switch] $Destroy
   )

   Process {
      # Call the REST API

      $idsToDelete = @()

      if ($Ids) {
         $idsToDelete = $Ids       
      }
      else {
         $idsToDelete = @($id[0])        
      }

      $deletedWorkItems = foreach ($wiId in $idsToDelete) {
         $resp = _callAPI -Method "DELETE" -Area 'wit' -Resource 'workitems'  `
            -Version $([VSTeamVersions]::Core) -id "$wiId" `
            -Querystring @{
            destroy = $Destroy            
         }

         _applyTypesToWorkItemDeleted -item $resp  
         
         $resp
      }

      return $deletedWorkItems
   }
}