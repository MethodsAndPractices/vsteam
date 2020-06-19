Set-StrictMode -Version Latest

Describe 'VSTeamInfo' {
   BeforeAll {
      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProjectCache.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"
   }

   Context 'Get-VSTeamInfo' {
      AfterAll {
         $Global:PSDefaultParameterValues.Remove("*-vsteam*:projectName")
      }

      It 'should return account and default project' {
         [VSTeamVersions]::Account = "mydemos"
         $Global:PSDefaultParameterValues['*-vsteam*:projectName'] = 'TestProject'

         ## Act
         $info = Get-VSTeamInfo

         ## Assert
         $info.Account | Should -Be "mydemos"
         $info.DefaultProject | Should -Be "TestProject"
      }
   }
}