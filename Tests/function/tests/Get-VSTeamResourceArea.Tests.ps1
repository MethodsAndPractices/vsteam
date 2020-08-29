Set-StrictMode -Version Latest

Describe 'VSTeamResourceArea' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      
      . "$baseFolder/Source/Private/applyTypes.ps1"
   }

   Context 'Get-VSTeamResourceArea' {
      BeforeAll {
         ## Arrange
         Mock _callAPI { return @{ value = @{ } } }
      }

      It 'Should return resources' {
         ## Act
         $actual = Get-VSTeamResourceArea

         ## Assert
         $actual | Should -Not -Be $null
      }
   }
}