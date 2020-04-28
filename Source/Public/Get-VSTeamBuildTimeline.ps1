function Get-VSTeamBuildTimeline {
   [CmdletBinding(DefaultParameterSetName = 'ByID')]
   param (
      [Parameter(ParameterSetName = 'ByID', ValueFromPipeline = $true, Mandatory= $true, Position=0)]
      [int[]] $BuildID,

      [Parameter(ParameterSetName = 'ByID')]
      [Alias('TimelineId')]
      [Guid] $Id,

      [Parameter(ParameterSetName = 'ByID')]
      [int] $ChangeId,

      [Parameter(ParameterSetName = 'ByID')]
      [Guid] $PlanId
   )

   DynamicParam {
      _buildProjectNameDynamicParam
   }

   Process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]
  
      foreach ($item in $BuildID) {
         # Build the url to return the single build

         $resource = "builds/$item/timeline"

         if($Id){
            $resource = "builds/$item/timeline/$Id"
         }

         $resp = _callAPI -method Get -ProjectName $projectName -Area 'build' -Resource $resource `
            -Version $([VSTeamVersions]::Build) `
            -Querystring @{
               'changeId'                 = $ChangeId
               'planId'                   = $PlanId              
            }

         _applyTypesToBuildTimelineResultType -item $resp

         Write-Output $resp
      }
   
   }
}