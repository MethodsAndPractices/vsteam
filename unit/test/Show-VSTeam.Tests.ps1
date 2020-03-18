Set-StrictMode -Version Latest
$env:Testing=$true
# The InModuleScope command allows you to perform white-box unit testing on the
# internal \(non-exported\) code of a Script Module, ensuring the module is loaded.
InModuleScope VSTeam {
   Describe 'Show-VSTeam' {
      Context 'Show-VSTeam' {
         Mock _getInstance { return 'https://dev.azure.com/test' }

         Mock Show-Browser -Verifiable

         Show-VSTeam

         It 'Should open browser' {
            Assert-VerifiableMock
         }
      }
   }
}