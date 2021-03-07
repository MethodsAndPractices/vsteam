function Show-VSTeam {
   [CmdletBinding(HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Show-VSTeam')]
   param ()

   process {
      _hasAccount

      Show-Browser "$(_getInstance)"
   }
}