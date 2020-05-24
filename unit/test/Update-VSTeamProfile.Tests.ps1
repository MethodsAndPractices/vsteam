Set-StrictMode -Version Latest

Describe 'VSTeamProfile' {
   BeforeAll {
      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamProfile.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"

      $expectedPath = "$HOME/vsteam_profiles.json"

      Mock Get-Content { return '' }
      # Waiting for bug fix in Pester5
      # Mock Test-Path { return $true }
   }

   Context 'Update-VSTeamProfile entry does not exist' {
      BeforeAll {
         Mock Get-VSTeamProfile { return '[{"Name":"test","URL":"https://dev.azure.com/test","Type":"Pat","Pat":"12345","Version":"VSTS"}]' | ConvertFrom-Json | ForEach-Object { $_ } }
      }

      It 'Should throw' {
         { Update-VSTeamProfile -Name Testing -PersonalAccessToken 678910 } | Should -Throw
      }
   }

   Context 'Update-VSTeamProfile with PAT to empty file' {
      BeforeAll {
         Mock Set-Content
         Mock Get-VSTeamProfile
         Mock Write-Warning -Verifiable
      }

      It 'Should save profile to disk' {
         Update-VSTeamProfile -name demos -PersonalAccessToken 12345

         Should -InvokeVerifiable
      }
   }

   Context 'Update-VSTeamProfile with securePersonalAccessToken' {
      BeforeAll {
         Mock Set-Content
         Mock Get-VSTeamProfile { return '[{"Name":"test","URL":"https://dev.azure.com/test/","Type":"Pat","Pat":"12345","Version":"VSTS"}]' | ConvertFrom-Json | ForEach-Object { $_ } }
      }

      It 'Should update profile' {
         $password = '678910' | ConvertTo-SecureString -AsPlainText -Force

         Update-VSTeamProfile -Name test -SecurePersonalAccessToken $password

         Should -Invoke Set-Content -ParameterFilter {
            $Path -eq $expectedPath -and
            $Value -like "*OjY3ODkxMA==*" -and
            $Value -like "*https://dev.azure.com/test*" -and
            $Value -like "*VSTS*"
         }
      }
   }

   Context 'Update-VSTeamProfile with PAT' {
      BeforeAll {
         Mock Set-Content
         Mock Get-VSTeamProfile { return '[{"Name":"test","URL":"https://dev.azure.com/test/","Type":"Pat","Pat":"12345","Version":"VSTS"}]' | ConvertFrom-Json | ForEach-Object { $_ } }
      }

      It 'Should update profile' {
         Update-VSTeamProfile -Name test -PersonalAccessToken 678910

         Should -Invoke Set-Content -ParameterFilter {
            $Path -eq $expectedPath -and
            $Value -like "*OjY3ODkxMA==*" -and
            $Value -like "*https://dev.azure.com/test*" -and
            $Value -like "*VSTS*" }
      }
   }

   Context 'Update-VSTeamProfile with old URL' {
      BeforeAll {
         Mock Test-Path { return $true }
         Mock Get-Content { return '[{"Name":"test","URL":"https://test.visualstudio.com","Type":"Pat","Pat":"12345","Version":"VSTS"}]' }
         Mock Set-Content
      }

      It 'Should update profile with new URL' {
         Update-VSTeamProfile -Name test -PersonalAccessToken 678910
         Should -Invoke Set-Content -ParameterFilter {
            $Path -eq $expectedPath -and
            $Value -like "*OjY3ODkxMA==*" -and
            $Value -like "*https://dev.azure.com/test*" -and
            $Value -like "*VSTS*" }
      }
   }
}