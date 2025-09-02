function New-VSTeamWorkItemRelation {
   [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "", Scope="Function", Justification="No calls against the Azure DevOps API are done. No persistent changes.")]
   [CmdletBinding(DefaultParameterSetName="ById", HelpUri="https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/New-VSTeamWorkItemRelation")]
   param(
      [Parameter(Mandatory, ValueFromPipeline, ParameterSetName="ByObject")]
      [PSCustomObject[]]$InputObject,

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

      $results = @()

      if ($PSCmdlet.ParameterSetName -eq "ByObject") {

         if ($null -eq $PSBoundParameters.Index) {

            $results += [PSCustomObject]@{
               Id = $Id[0]
               RelationType = $RelationType
               Operation = "add"
               Comment = $Comment
               Index = "-"
            }

         } else {

            $results += [PSCustomObject]@{
               Id = $null
               RelationType = $null
               Operation = $Operation.ToLower()
               Comment = $Comment
               Index = $PSBoundParameters.Index
            }
         }

      } elseif ($PSCmdlet.ParameterSetName -eq "ById") {

         foreach ($item in $Id) {

            $results += [PSCustomObject]@{
               Id = $item
               RelationType = $RelationType
               Operation = 'add'
               Comment = $Comment
               Index = '-'
            }

         }

      } else {

         $results += [PSCustomObject]@{
            Id = $null
            RelationType = $RelationType
            Operation = $Operation.ToLower()
            Comment = $Comment
            Index = $index
         }

      }

      foreach ($item in $results){
         _applyTypesToWorkItemRelation $item
         return $item
      }
   }
}