Set-StrictMode -Version Latest

Describe 'VSTeamProfile' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath      
      . "$baseFolder/Source/Public/Get-VSTeamProfile.ps1"
      
      ## Arrange
      $expectedPath = "$HOME/vsteam_profiles.json"

      Mock Set-Content      
      Mock Get-VSTeamProfile { return Open-SampleFile 'Get-VSTeamProfile.json' | ForEach-Object { $_ } }
   }

   Context 'Remove-VSTeamProfile' {
      It 'should save remaining profiles to disk' {
         ## Act
         Remove-VSTeamProfile test

         ## Assert
         Should -Invoke Set-Content -Exactly -Times 1 -Scope It -ParameterFilter {
            $Path -eq $expectedPath -and 
            $Value -Notlike "*test*"
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