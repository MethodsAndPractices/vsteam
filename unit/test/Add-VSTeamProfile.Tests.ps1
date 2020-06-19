Set-StrictMode -Version Latest

Describe 'VSTeamProfile' {
   BeforeAll {
      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamProfile"
      . "$PSScriptRoot/../../Source/Public/$sut"

      $expectedPath = "$HOME/vsteam_profiles.json"

      Mock Set-Content
   }

   Context 'Add-VSTeamProfile' {
      BeforeAll {
         Mock Write-Error
         Mock Get-VSTeamProfile
         Mock _isOnWindows { return $true }
         Mock _convertSecureStringTo_PlainText { return '' }
      }

      It 'on Windows no data provided should save profile to disk' {
         $emptySecureString = ConvertTo-SecureString 'does not matter because mock is going to return empty string' -AsPlainText -Force

         Add-VSTeamProfile -Account testing -SecurePersonalAccessToken $emptySecureString

         Should -Invoke Set-Content -Exactly -Scope It -Times 0
         Should -Invoke Write-Error -Exactly -Scope It -Times 1 -ParameterFilter {
            $Message -eq 'Personal Access Token must be provided if you are not using Windows Authentication; please see the help.'
         }
      }

      It 'with PAT to empty file should save profile to disk' {
         Add-VSTeamProfile -Account demos -PersonalAccessToken 12345

         Should -Invoke Set-Content -Exactly -Scope It -Times 1 -ParameterFilter {
            $Path -eq $expectedPath -and $Value -like "*https://dev.azure.com/demos*" -and $Value -like "*VSTS*"
         }
      }

      It 'with PAT to empty array should save profile to disk' {
         Add-VSTeamProfile -Account demos -PersonalAccessToken 12345 -Version VSTS

         Should -Invoke Set-Content -Exactly -Scope It -Times 1 -ParameterFilter {
            $Path -eq $expectedPath -and $Value -like "*https://dev.azure.com/demos*" -and $Value -like "*VSTS*"
         }
      }

      It 'with OAuth to empty array should save profile to disk' {
         Add-VSTeamProfile -Account demos -PersonalAccessToken 12345 -Version VSTS -UseBearerToken

         Should -Invoke Set-Content -Exactly -Scope It -Times 1 -ParameterFilter {
            $Path -eq $expectedPath -and $Value -like "*https://dev.azure.com/demos*" -and $Value -like "*VSTS*"
         }
      }
   }

   Context 'Add-VSTeamProfile with PAT exisiting entry' {
      BeforeAll {
         Mock Get-VSTeamProfile { return '[{"Name":"test","URL":"https://dev.azure.com/test","Type":"Pat","Pat":"12345","Version":"VSTS"}]' | ConvertFrom-Json | ForEach-Object { $_ } }
      }

      It 'Should save profile to disk' {
         Add-VSTeamProfile -Account demos -PersonalAccessToken 12345 -Version TFS2018

         Should -Invoke Set-Content -Exactly -Scope It -Times 1 -ParameterFilter {
            $Path -eq $expectedPath -and $Value -like "*https://dev.azure.com/demos*" -and $Value -like "*https://dev.azure.com/test*" -and $Value -like "*TFS2018*"
         }
      }
   }

   Context 'Add-VSTeamProfile TFS default to TFS2017 with Windows Auth' {
      BeforeAll {
         Mock _isOnWindows { return $true }
         Mock Get-VSTeamProfile { return '[{"Name":"test","URL":"https://dev.azure.com/test/","Type":"Pat","Pat":"12345","Version":"VSTS"}]' | ConvertFrom-Json | ForEach-Object { $_ } }
      }

      It 'Should save profile to disk' {
         Add-VSTeamProfile -Account http://localhost:8080/tfs/defaultcollection -UseWindowsAuthentication

         Should -Invoke Set-Content -Exactly -Scope It -Times 1 -ParameterFilter {
            $Path -eq $expectedPath -and $Value -like "*OnPremise*" -and $Value -like "*http://localhost:8080/tfs/defaultcollection*" -and $Value -like "*TFS2017*"
         }
      }
   }

   Context 'Add-VSTeamProfile TFS default to TFS2017' {
      BeforeAll {
         Mock Get-VSTeamProfile { return '[{"Name":"test","URL":"https://dev.azure.com/test/","Type":"Pat","Pat":"12345","Version":"VSTS"}]' | ConvertFrom-Json | ForEach-Object { $_ } }
      }

      It 'Should save profile to disk' {
         Add-VSTeamProfile -Account http://localhost:8080/tfs/defaultcollection -PersonalAccessToken 678910

         Should -Invoke Set-Content -Exactly -Scope It -Times 1 -ParameterFilter {
            $Path -eq $expectedPath -and $Value -like "*OjY3ODkxMA==*" -and $Value -like "*http://localhost:8080/tfs/defaultcollection*" -and $Value -like "*TFS2017*"
         }
      }
   }

   Context 'Add-VSTeamProfile with PAT replace exisiting entry' {
      BeforeAll {
         Mock Get-VSTeamProfile { return '[{"Name":"test","URL":"https://dev.azure.com/test/","Type":"Pat","Pat":"12345","Version":"VSTS"}]' | ConvertFrom-Json | ForEach-Object { $_ } }
      }

      It 'Should save profile to disk' {
         Add-VSTeamProfile -Account test -PersonalAccessToken 678910
         Should -Invoke Set-Content -Exactly -Scope It -Times 1 -ParameterFilter {
            $Path -eq $expectedPath -and $Value -like "*OjY3ODkxMA==*" -and $Value -like "*https://dev.azure.com/test*" -and $Value -like "*VSTS*"
         }
      }
   }

   Context 'Add-VSTeamProfile with existing old URL' {
      BeforeAll {
         Mock Test-Path { return $true }
         Mock Get-Content { return '[{"Name":"test","URL":"https://test.visualstudio.com","Type":"Pat","Pat":"12345","Version":"VSTS"}]' }
      }

      It 'Should save profile with new URL to disk' {
         Add-VSTeamProfile -Account test -PersonalAccessToken 678910
         Should -Invoke Set-Content -Exactly -Scope It -Times 1 -ParameterFilter {
            $Path -eq $expectedPath -and $Value -like "*OjY3ODkxMA==*" -and $Value -like "*https://dev.azure.com/test*" -and $Value -like "*VSTS*"
         }
      }
   }
}
