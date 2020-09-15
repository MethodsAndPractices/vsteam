function Show-VSTeam {
   [CmdletBinding(HelpUri='https://methodsandpractices.github.io/vsteam-docs/modules/vsteam/Show-VSTeam')]
   param ()

   process {
      _hasAccount

      Show-Browser "$(_getInstance)"
   }
}