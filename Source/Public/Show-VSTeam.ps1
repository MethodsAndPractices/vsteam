function Show-VSTeam {
   [CmdletBinding()]
   param ()

   process {
      _hasAccount

      Show-Browser "$(_getInstance)"
   }
}