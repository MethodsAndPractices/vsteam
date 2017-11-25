Set-StrictMode -Version Latest

Get-Module team | Remove-Module -Force
Import-Module $PSScriptRoot\..\..\src\profile.psm1 -Force

InModuleScope profile {
   Describe 'Profile' {
      $expectedPath = "$HOME/vsteam_profiles.json"
$contents = @"
      [
         {
            "Name": "http://localhost:8080/tfs/defaultcollection",
            "URL": "http://localhost:8080/tfs/defaultcollection",
            "Pat": "",
            "Type": "OnPremise",
            "Version": "TFS2017"
         },
         {
            "Name": "http://192.168.1.3:8080/tfs/defaultcollection",
            "URL": "http://192.168.1.3:8080/tfs/defaultcollection",
            "Pat": "OnE2cXpseHk0YXp3dHpz",
            "Type": "Pat",
            "Version": "TFS2017"
         },
         {
            "Name": "test",
            "URL": "https://test.visualstudio.com",
            "Pat": "OndrejR0ZHpwbDM3bXUycGt5c3hm",
            "Type": "Pat",
            "Version": "VSTS"
         }
      ]
"@

      Context 'Remove-VSTeamProfile' {
         Mock Set-Content { } -Verifiable -ParameterFilter { $Path -eq $expectedPath -and [string]$Value -eq '' }
         Mock Set-Content { }
         Mock Get-VSTeamProfile { return '[{"Name":"test","URL":"https://test.visualstudio.com","Type":"Pat","Pat":"12345","Version":"VSTS"}]' | ConvertFrom-Json | ForEach-Object { $_ } }

         Remove-VSTeamProfile test

         It 'Should save profile to disk' {
            Assert-VerifiableMocks
         }
      }

      Context 'Remove-VSTeamProfile entry does not exist' {
         Mock Set-Content { } -Verifiable -ParameterFilter { $Path -eq $expectedPath -and $Value -like "*https://test.visualstudio.com*" }
         Mock Set-Content { }
         Mock Get-VSTeamProfile { return '[{"Name":"test","URL":"https://test.visualstudio.com","Type":"Pat","Pat":"12345","Version":"VSTS"}]' | ConvertFrom-Json | ForEach-Object { $_ } }

         Remove-VSTeamProfile demos

         It 'Should save profile to disk' {
            Assert-VerifiableMocks
         }
      }

      Context 'Add-VSTeamProfile with PAT to empty file' {
         Mock Set-Content { } -Verifiable -ParameterFilter { $Path -eq $expectedPath -and $Value -like "*https://demos.visualstudio.com*" -and $Value -like "*VSTS*" }
         Mock Set-Content { }
         Mock Get-VSTeamProfile { }

         Add-VSTeamProfile -Account demos -PersonalAccessToken 12345

         It 'Should save profile to disk' {
            Assert-VerifiableMocks
         }
      }

      Context 'Add-VSTeamProfile with PAT to empty array' {
         Mock Set-Content { } -Verifiable -ParameterFilter { $Path -eq $expectedPath -and $Value -like "*https://demos.visualstudio.com*" -and $Value -like "*VSTS*" }
         Mock Set-Content { }
         Mock Get-VSTeamProfile { }

         Add-VSTeamProfile -Account demos -PersonalAccessToken 12345 -Version VSTS

         It 'Should save profile to disk' {
            Assert-VerifiableMocks
         }
      }

      Context 'Add-VSTeamProfile with PAT exisiting entry' {
         Mock Set-Content { } -Verifiable -ParameterFilter { $Path -eq $expectedPath -and $Value -like "*https://demos.visualstudio.com*" -and $Value -like "*https://test.visualstudio.com*" -and $Value -like "*TFS2018*" }
         Mock Set-Content { }
         Mock Get-VSTeamProfile { return '[{"Name":"test","URL":"https://test.visualstudio.com","Type":"Pat","Pat":"12345","Version":"VSTS"}]' | ConvertFrom-Json | ForEach-Object { $_ } }

         Add-VSTeamProfile -Account demos -PersonalAccessToken 12345 -Version TFS2018

         It 'Should save profile to disk' {
            Assert-VerifiableMocks
         }
      }

      Context 'Add-VSTeamProfile TFS default to TFS2017' {
         Mock Set-Content { } -Verifiable -ParameterFilter { $Path -eq $expectedPath -and $Value -like "*OjY3ODkxMA==*" -and $Value -like "*http://localhost:8080/tfs/defaultcollection*" -and $Value -like "*TFS2017*" }
         Mock Set-Content { }
         Mock Get-VSTeamProfile { return '[{"Name":"test","URL":"https://test.visualstudio.com/","Type":"Pat","Pat":"12345","Version":"VSTS"}]' | ConvertFrom-Json | ForEach-Object { $_ } }

         Add-VSTeamProfile -Account http://localhost:8080/tfs/defaultcollection -PersonalAccessToken 678910

         It 'Should save profile to disk' {
            Assert-VerifiableMocks
         }
      }

      Context 'Add-VSTeamProfile with PAT replace exisiting entry' {
         Mock Set-Content { } -Verifiable -ParameterFilter { $Path -eq $expectedPath -and $Value -like "*OjY3ODkxMA==*" -and $Value -like "*https://test.visualstudio.com*" -and $Value -like "*VSTS*" }
         Mock Set-Content { }
         Mock Get-VSTeamProfile { return '[{"Name":"test","URL":"https://test.visualstudio.com/","Type":"Pat","Pat":"12345","Version":"VSTS"}]' | ConvertFrom-Json | ForEach-Object { $_ } }

         Add-VSTeamProfile -Account test -PersonalAccessToken 678910

         It 'Should save profile to disk' {
            Assert-VerifiableMocks
         }
      }

      Context 'Get-VSTeamProfile empty profiles file' {
         Mock Test-Path { return $true }
         Mock Get-Content { return '' }

         $actual = Get-VSTeamProfile
      
         It 'Should return 0 profiles' {
            $actual | Should BeNullOrEmpty
         }
      }

      Context 'Get-VSTeamProfile invalid profiles file' {
         Mock Test-Path { return $true }
         Mock Get-Content { return 'Not Valid JSON. This might happen if someone touches the file.' }
         Mock Write-Error { } -Verifiable

         $actual = Get-VSTeamProfile
      
         It 'Should return 0 profiles' {
            $actual | Should BeNullOrEmpty
            Assert-VerifiableMocks
         }
      }

      Context 'Get-VSTeamProfile no profiles' {
         Mock Test-Path { return $false }

         $actual = Get-VSTeamProfile
      
         It 'Should return 0 profiles' {
            $actual | Should BeNullOrEmpty
         }
      }

      Context 'Get-VSTeamProfile by name' {         
                  
         Mock Test-Path { return $true }
         Mock Get-Content { return $contents }
         
         $actual = Get-VSTeamProfile test
               
         It 'Should return 1 profile' {
            $actual.URL | Should be 'https://test.visualstudio.com'
         }
         
         It 'Profile Should by Pat' {
            $actual.Type | Should be 'Pat'
         }
      }

      Context 'Get-VSTeamProfile' {
         Mock Test-Path { return $true }
         Mock Get-Content { return $contents }

         $actual = Get-VSTeamProfile
      
         It 'Should return 3 profiles' {
            $actual.Length | Should be 3
         }

         It '1st profile Should by OnPremise' {
            $actual[0].Type | Should be 'OnPremise'
         }
      }
   }
}