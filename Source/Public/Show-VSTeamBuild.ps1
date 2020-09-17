function Show-VSTeamBuild {
   [CmdletBinding(DefaultParameterSetName = 'ByID',
    HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/Show-VSTeamBuild')]
   param (
      [Parameter(ParameterSetName = 'ByID', ValueFromPipelineByPropertyName = $true)]
      [Alias('BuildID')]
      [int[]] $Id,

      [Parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName
   )

   process {
      Show-Browser "$(_getInstance)/$ProjectName/_build/index?buildId=$Id"
   }
}
