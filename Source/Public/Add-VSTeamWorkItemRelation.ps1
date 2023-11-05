function Add-VSTeamWorkItemRelation {
   [CmdletBinding(SupportsShouldProcess, ConfirmImpact = "Medium", HelpUri = 'https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Add-VSTeamWorkItemRelation')]
   param (
      [Parameter(Mandatory, Position=0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
      [int[]]$Id,
      [ArgumentCompleter([vsteam_lib.WorkItemRelationTypeCompleter])]
      [Parameter(Mandatory, Position=1)]
      [string]$RelationType,
      [Parameter(Mandatory, Position=2)]
      [int]$OfRelatedId,
      [switch]$Force
   )

   process {
      $relations = $Id | New-VSTeamWorkItemRelation -RelationType $RelationType
      if ($Force -or $pscmdlet.ShouldProcess($Id, "add relations to work items")) {
         Update-VSTeamWorkItem -Id $OfRelatedId -Relations $relations
      }
   }
}