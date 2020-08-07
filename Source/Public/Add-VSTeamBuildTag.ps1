# Adds a tag to a build.
# Get-VSTeamOption 'build' 'tags'
# id              : 6e6114b2-8161-44c8-8f6c-c5505782427f
# area            : build
# resourceName    : tags
# routeTemplate   : {project}/_apis/{area}/builds/{buildId}/{resource}/{*tag}

function Add-VSTeamBuildTag {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Low")]
   param(
      [parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Position = 0)]
      [string[]] $Tags,
      
      [parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
      [Alias('BuildID')]
      [int[]] $Id,

      [switch] $Force,
      
      [ProjectValidateAttribute()]
      [ArgumentCompleter([ProjectCompleter])]
      [Parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
      [string] $ProjectName
   )
   process {
      foreach ($item in $id) {
         if ($Force -or $pscmdlet.ShouldProcess($item, "Add-VSTeamBuildTag")) {
            foreach ($tag in $tags) {
               _callAPI -Method PUT -ProjectName $projectName `
                  -Area "build/builds/$id" `
                  -Resource tags `
                  -id $tag `
                  -Version $(_getApiVersion Build) | Out-Null
            }
         }
      }
   }
}
