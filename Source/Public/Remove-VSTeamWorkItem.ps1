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

      if ($PSCmdlet.ParameterSetName -eq "List") {

         if($null -eq $Ids) {
            throw "No Ids given, array was null" 
         }

         $idsToDelete = $Ids       
      }
      else {

         # work item IDs in AzD cannot be lower than 1. First work item id is always 1.
         if($Id -lt 1) {
            throw "given work item Id has to be greater than 0" 
         }

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