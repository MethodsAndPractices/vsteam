function Add-VSTeamBuildTag {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Low")]
   param(
      [parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Position = 0)]
      [string[]] $Tags,

      [parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
      [Alias('BuildID')]
      [int[]] $Id,

      [switch] $Force
   )
    
   DynamicParam {
      _buildProjectNameDynamicParam
   }

   Process {
      $ProjectName = $PSBoundParameters["ProjectName"]
        
      foreach ($item in $id) {
         if ($Force -or $pscmdlet.ShouldProcess($item, "Add-VSTeamBuildTag")) {
            foreach ($tag in $tags) {
               # Call the REST API
               _callAPI -ProjectName $projectName -Area 'build' -Resource "builds/$Id/tags" `
                  -Method Put -Querystring @{tag = $tag} -Version $([VSTeamVersions]::Build) | Out-Null
            }
         }
      }
   }
}