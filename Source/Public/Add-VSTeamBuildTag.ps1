# Adds a tag to a build.
#
# Get-VSTeamOption 'build' 'tags'
# id              : 6e6114b2-8161-44c8-8f6c-c5505782427f
# area            : build
# resourceName    : tags
# routeTemplate   : {project}/_apis/{area}/builds/{buildId}/{resource}/{*tag}
# http://bit.ly/Add-VSTeamBuildTag

function Add-VSTeamBuildTag {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Low",
    HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Add-VSTeamBuildTag')]
   param(
      [parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Position = 0)]
      [string[]] $Tags,

      [parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
      [Alias('BuildID')]
      [int[]] $Id,

      [switch] $Force,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName
   )
   process {
      foreach ($item in $id) {
         if ($Force -or $pscmdlet.ShouldProcess($item, "Add-VSTeamBuildTag")) {
            foreach ($tag in $tags) {
               _callAPI -Method PUT -ProjectName $projectName `
                  -Area "build/builds/$id" `
                  -Resource "tags" `
                  -id $tag `
                  -Version $(_getApiVersion Build) | Out-Null
            }
         }
      }
   }
}
