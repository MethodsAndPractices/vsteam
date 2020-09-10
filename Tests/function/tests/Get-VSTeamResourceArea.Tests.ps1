Set-StrictMode -Version Latest

Describe 'VSTeamResourceArea' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
   }

   Context 'Get-VSTeamResourceArea' {
      BeforeAll {
         ## Arrange
         Mock _callAPI { Open-SampleFile 'Get-VSTeamResourceArea.json' }
      }

      It 'Should return resources' {
         ## Act
         $actual = Get-VSTeamResourceArea

         ## Assert
         $actual.Count | Should -Be 2
         $actual[0].name | Should -Be 'policy'
      }
   }
}