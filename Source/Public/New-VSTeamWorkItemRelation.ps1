function New-VSTeamWorkItemRelation {
   [CmdletBinding(DefaultParameterSetName="ById", HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/New-VSTeamWorkItemRelation')]
   param(
      [Parameter(Mandatory, ValueFromPipeline, ParameterSetName="ByObject")]
      [PSCustomObject[]]$ImputObject,
      [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, ParameterSetName="ById")]
      [Parameter(Mandatory, ParameterSetName="ByObject")]
      [int[]]$Id,
      [ArgumentCompleter([vsteam_lib.WorkItemRelationTypeCompleter])]
      [vsteam_lib.RelationTypeToReferenceNameAttribute()]
      [Parameter(Mandatory)]
      [string]$RelationType,
      [ValidateSet('Add', 'Remove', 'Replace')]
      [string]$Operation = 'Add',
      [string]$Comment
   )

   process {
      if ($PSCmdlet.ParameterSetName -eq "ByObject") {
         $ImputObject
      } else {
         foreach ($item in $Id) {
            $result = [PSCustomObject]@{
               Id = $item
               RelationType = $RelationType
               Operation = $Operation.ToLower()
               Comment = $Comment
            }
            _applyTypesToWorkItemRelation $result
            $result
         }
      }
   }

   end {
      if ($PSCmdlet.ParameterSetName -eq "ByObject") {
         $result = [PSCustomObject]@{
            Id = $Id[0]
            RelationType = $RelationType
            Operation = $Operation.ToLower()
            Comment = $Comment
         }
         _applyTypesToWorkItemRelation $result
         $result
      }
   }

}