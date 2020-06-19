Set-StrictMode -Version Latest

Describe 'VSTeamProfile' {
   BeforeAll {
      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")
      
      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamProfile.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"
      
      ## Arrange
      $expectedPath = "$HOME/vsteam_profiles.json"

      Mock Set-Content { }
      Mock Get-VSTeamProfile { return '[{"Name":"test","URL":"https://dev.azure.com/test","Type":"Pat","Pat":"12345","Version":"VSTS"}]' | ConvertFrom-Json | ForEach-Object { $_ } }
   }

   Context 'Remove-VSTeamProfile' {
      It 'should save remaining profiles to disk' {
         ## Act
         Remove-VSTeamProfile test

         ## Assert
         Should -Invoke Set-Content -Exactly -Times 1 -Scope It -ParameterFilter {
            $Path -eq $expectedPath -and ([string]$Value -eq '')
         }
      }

      It 'entry does not exist should save original profiles to disk' {
         ## Act
         Remove-VSTeamProfile demos

         ## Assert
         Should -Invoke Set-Content -Exactly -Times 1 -Scope It -ParameterFilter {
            $Path -eq $expectedPath -and $Value -like "*https://dev.azure.com/test*"
         }
      }
   }
}