function Get-VSTeamWorkItemRelation {
   [CmdletBinding(HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Get-VSTeamWorkItemRelation')]
   param (
      [int]$Id
   )

   $relations = Get-VSTeamWorkItem -Id $Id -Expand Relations -Verbose | Select-Object -ExpandProperty Relations
   $i = 0
   foreach ($relation in $relations) {
      $relatedId = $relation.Url.split("/")[-1]
      $r = New-VSTeamWorkItemRelation -Id $relatedId -RelationType $relation.Attributes.Name -Comment $relation.Attributes.Comment
      $r.Index = $i++
      $r
   }

}