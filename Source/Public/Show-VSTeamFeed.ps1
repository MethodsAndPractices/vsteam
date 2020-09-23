function Show-VSTeamFeed {
   [CmdletBinding(HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Show-VSTeamFeed')]
   param(
      [Parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Position = 0)]
      [Alias('ID')]
      [string] $Name
   )

   process {
      _hasAccount

      Show-Browser "$(_getInstance)/_packaging?feed=$Name&_a=feed"
   }
}