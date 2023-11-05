function Remove-VSTeamWorkItemRelation {
   [CmdletBinding(SupportsShouldProcess, ConfirmImpact = "Medium", HelpUri = 'https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Remove-VSTeamWorkItemRelation')]
   param (
      [Parameter(Mandatory, Position=0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
      [int[]]$Id,
      [Parameter(Mandatory, Position=2)]
      [int[]]$FromRelatedId,
      [switch]$Force
   )

   process {
      foreach($item in $Id) {
         $relations = Get-VSTeamWorkItemRelation -Id $item
         $relationsToRemove = @()
         foreach($relatedId in $FromRelatedId) {
            $relation = $relations | Where-Object Id -eq $relatedId
            if ($relation) {
               $relationsToRemove += New-VSTeamWorkItemRelation -Index $relation.Index -Operation Remove
            }
         }
         if ($Force -or $pscmdlet.ShouldProcess($Id, "remove relations from work items")) {
            Update-VSTeamWorkItem -Id $item -Relations $relationsToRemove
         }
      }
   }
}