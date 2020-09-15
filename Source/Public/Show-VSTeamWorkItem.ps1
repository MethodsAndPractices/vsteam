function Show-VSTeamWorkItem {
   [CmdletBinding(HelpUri='https://methodsandpractices.github.io/vsteam-docs/modules/vsteam/Show-VSTeamWorkItem')]
   param(
      [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Position = 0)]
      [Alias('WorkItemID')]
      [int] $Id,

      [Parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName
   )

   process {
      Show-Browser "$(_getInstance)/$ProjectName/_workitems/edit/$Id"
   }
}
