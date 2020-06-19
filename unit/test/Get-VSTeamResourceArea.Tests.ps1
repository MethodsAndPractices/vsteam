Set-StrictMode -Version Latest

Describe 'VSTeamResourceArea' {
   BeforeAll {
      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProjectCache.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Private/applyTypes.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"
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