function Switch-VSTeamWorkItemParent {
   [CmdletBinding(SupportsShouldProcess, ConfirmImpact = "Medium", HelpUri = 'https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Switch-VSTeamWorkItemParent')]
   param (
      [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
      [int[]]$Id,
      [Parameter(Mandatory)]
      [int]$ParentId,
      [switch]$AddParent,
      [switch]$Force
   )

   process {

      $workItem = $null

      foreach($item in $Id) {
         $ParentNeeded = $false
         $workItem = Get-VSTeamWorkItem -Id $item -Expand Relations

         if ($null -eq $workItem.Relations -and $AddParent) {
            $ParentNeeded = $true
         }
         elseif ($workItem.Relations) {

                  $relations = $workItem | Select-Object -ExpandProperty Relations
                  $index = 0
                  $hasParent = $false

                  foreach($relation in $relations) {

                     if ($relation.rel -eq 'System.LinkTypes.Hierarchy-Reverse') {
                           $hasParent = $true
                           if ($relation.url.split('/')[-1] -ne $ParentId) {

                              $patch = New-VSTeamWorkItemRelation -Index $index -Operation Remove | New-VSTeamWorkItemRelation -Id $ParentId -RelationType Parent

                              if ($Force -or $pscmdlet.ShouldProcess($item, "Update-WorkItem")) {
                                 $workItem = Update-VSTeamWorkItem -Id $item -Relations $patch
                              }

                              break
                           }
                     }
                     $index++

                  }

                  if (-not $hasParent -and $AddParent) {
                     $ParentNeeded = $true
                  }
               }


         if ($ParentNeeded -and ($Foce -or $pscmdlet.ShouldProcess($Id, "Updates the parent work item"))) {

            $newRelation = New-VSTeamWorkItemRelation -Id $ParentId -RelationType Parent
            $workItem = Update-VSTeamWorkItem -Id $item -Relations $newRelation

         }

         return $workItem
      }
   }
}