Set-StrictMode -Version Latest

Describe 'VSTeam' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      ## Arrange
      Mock Show-Browser -Verifiable
      Mock _getInstance { return 'https://dev.azure.com/test' }
   }

   Context 'Show-VSTeam' {
      It 'Should open browser' {
         ## Act
         Show-VSTeam
         
         ## Assert
         Should -InvokeVerifiable
      }
   }
}