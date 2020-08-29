Set-StrictMode -Version Latest

Describe 'VSTeam' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock Show-Browser -Verifiable
   }

   Context 'Show-VSTeam' {
      It 'Should open browser' {
         Show-VSTeam
         
         Should -InvokeVerifiable
      }
   }
}