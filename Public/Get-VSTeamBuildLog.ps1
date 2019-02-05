function Get-VSTeamBuildLog {
   [CmdletBinding(DefaultParameterSetName = 'ByID')]
   param (
      [Parameter(Mandatory = $true, ParameterSetName = 'ByID', ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
      [Alias('BuildID')]
      [int[]] $Id,      
      [int] $Index
   )

   DynamicParam {
      _buildProjectNameDynamicParam
   }

   process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      foreach ($item in $id) {
         if (-not $Index) {
            # Build the url to return the logs of the build
            # Call the REST API to get the number of logs for the build
            $resp = _callAPI -ProjectName $projectName -Area 'build' -Resource "builds/$item/logs" `
               -Version $([VSTeamVersions]::Build)

            $fullLogIndex = $($resp.count - 1)
         }
         else {
            $fullLogIndex = $Index
         }

         # Now call REST API with the index for the fullLog
         # Build the url to return the single build
         # Call the REST API to get the number of logs for the build
         $resp = _callAPI -ProjectName $projectName -Area 'build' -Resource "builds/$item/logs" -id $fullLogIndex `
            -Version $([VSTeamVersions]::Build)

         Write-Output $resp
      }     
   }
}