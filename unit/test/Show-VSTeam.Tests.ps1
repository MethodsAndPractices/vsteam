Set-StrictMode -Version Latest

Describe 'VSTeam' {
   BeforeAll {
      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProjectCache.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"

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