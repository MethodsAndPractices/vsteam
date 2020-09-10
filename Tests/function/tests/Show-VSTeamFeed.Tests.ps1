Set-StrictMode -Version Latest

Describe 'VSTeamFeed' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      ## Arrange
      Mock Show-Browser
      Mock _getInstance { return 'https://dev.azure.com/test' }
   }

   Context 'Show-VSTeamFeed' {
      It 'by name should call show-browser' {
         ## Act
         Show-VSTeamFeed -Name module

         ## Assert
         Should -Invoke Show-Browser
      }

      It 'by id should call show-browser' {
         ## Act
         Show-VSTeamFeed -Id '00000000-0000-0000-0000-000000000000'

         ## Assert
         Should -Invoke Show-Browser
      }
   }
}