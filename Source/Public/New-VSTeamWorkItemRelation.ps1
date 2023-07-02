function New-VSTeamWorkItemRelation {
   [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Scope="Function", Justification='We still are not doing any persistent changes')]   
   [CmdletBinding(DefaultParameterSetName="ById", HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/New-VSTeamWorkItemRelation')]
   param(
      [Parameter(Mandatory, ValueFromPipeline, ParameterSetName="ByObject")]
      [PSCustomObject[]]$ImputObject,
      [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, ParameterSetName="ById")]
      [Parameter(ParameterSetName="ByObject")]
      [int[]]$Id,
      [ArgumentCompleter([vsteam_lib.WorkItemRelationTypeCompleter])]
      [vsteam_lib.RelationTypeToReferenceNameAttribute()]
      [Parameter(Mandatory, ParameterSetName="ById")]
      [Parameter(ParameterSetName="ByObject")]
      [string]$RelationType,
      [ValidateSet('Remove', 'Replace')]
      [Parameter(Mandatory, ParameterSetName="ByIndex")]
      [Parameter(ParameterSetName="ByObject")]
      [string]$Operation,
      [Parameter(Mandatory, ParameterSetName="ByIndex")]
      [Parameter(ParameterSetName="ByObject")]
      [int]$Index,
      [string]$Comment
   )

   process {
      if ($PSCmdlet.ParameterSetName -eq "ByObject") {
         $ImputObject
      } elseif ($PSCmdlet.ParameterSetName -eq "ById") {
         foreach ($item in $Id) {
            $result = [PSCustomObject]@{
               Id = $item
               RelationType = $RelationType
               Operation = 'add'
               Comment = $Comment
               Index = '-'
            }
            _applyTypesToWorkItemRelation $result
            $result
         }
      } else {
         $result = [PSCustomObject]@{
            Id = $null
            RelationType = $RelationType
            Operation = $Operation.ToLower()
            Comment = $Comment
            Index = $index
         }
         _applyTypesToWorkItemRelation $result
         $result
      }
   }

   end {
      if ($PSCmdlet.ParameterSetName -eq "ByObject") {
         if ($null -eq $PSBoundParameters.Index) {
            $result = [PSCustomObject]@{
               Id = $Id[0]
               RelationType = $RelationType
               Operation = "add"
               Comment = $Comment
               Index = "-"
            }
         } else {
            $result = [PSCustomObject]@{
               Id = $null
               RelationType = $null
               Operation = $Operation.ToLower()
               Comment = $Comment
               Index = $PSBoundParameters.Index
            }
         }
         _applyTypesToWorkItemRelation $result
         $result
      }
   }

}