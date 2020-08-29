Set-StrictMode -Version Latest

Describe 'VSTeamFeed' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable

      Mock Show-Browser
   }

   Context 'Show-VSTeamFeed' {
      It 'by name should call show-browser' {
         Show-VSTeamFeed -Name module

         Should -Invoke Show-Browser
      }

      It 'by id should call show-browser' {
         Show-VSTeamFeed -Id '00000000-0000-0000-0000-000000000000'

         Should -Invoke Show-Browser
      }
   }
}