function Get-VSTeamBuildTimeline {
   [CmdletBinding(HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Get-VSTeamBuildTimeline')]
   param (
      [Parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Mandatory = $true, Position = 1)]
      [int[]] $Id,

      [Guid] $TimelineId,

      [int] $ChangeId,

      [Guid] $PlanId,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName
   )

   Process {
      foreach ($item in $Id) {
         # Build the url to return the single build

         $resource = "builds/$item/timeline"

         if ($TimelineId) {
            $resource = "builds/$item/timeline/$TimelineId"
         }

         $resp = _callAPI -ProjectName $projectName `
            -Area 'build' `
            -Resource $resource `
            -Version $([vsteam_lib.Versions]::Build) `
            -Querystring @{
            'changeId' = $ChangeId
            'planId'   = $PlanId
         }

         _applyTypesToBuildTimelineResultType -item $resp

         Write-Output $resp
      }
   }
}