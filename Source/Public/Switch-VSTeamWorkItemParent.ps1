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
      foreach($item in $Id) {
         $ParentNeeded = $false
         $wi = Get-VSTeamWorkItem -Id $item -Expand Relations
         if ($null -eq $wi.Relations -and $AddParent) {
            $ParentNeeded = $true
         } else {
            if ($wi.Relations) {
               $relations = $wi | Select-Object -ExpandProperty Relations
               $index = 0
               $hasParent = $false
               foreach($relation in $relations) {
                  if ($relation.rel -eq 'System.LinkTypes.Hierarchy-Reverse') {
                        $hasParent = $true
                        if ($relation.url.split('/')[-1] -ne $ParentId) {
                           $patch = New-VSTeamWorkItemRelation -Index $index -Operation Remove | New-VSTeamWorkItemRelation -Id $ParentId -RelationType Parent
                           if ($Force -or $pscmdlet.ShouldProcess($item, "Update-WorkItem")) {
                              $wi = Update-VSTeamWorkItem -Id $item -Relations $patch
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
         }

         if ($ParentNeeded -and ($Foce -or $pscmdlet.ShouldProcess($Id, "Update-WorkItem"))) {
            $wi = Update-VSTeamWorkItem -Id $item -Relations (New-VSTeamWorkItemRelation -Id $ParentId -RelationType Parent)
         }
         $wi
      }
   }
}