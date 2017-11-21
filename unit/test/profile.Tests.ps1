Set-StrictMode -Version Latest

Get-Module team | Remove-Module -Force
Import-Module $PSScriptRoot\..\..\src\profile.psm1 -Force

InModuleScope profile {
   Describe 'Profile' {
      Context 'Add-VSTeamProfile with PAT to empty file' {
         $expectedPath = "$HOME/profiles.json"
         Mock Set-Content { } -Verifiable -ParameterFilter { $Path -eq $expectedPath -and $Value -like "*https://demonstrations.visualstudio.com*" }
         Mock Set-Content { }
         Mock Get-VSTeamProfile { return '[]' | ConvertFrom-Json }

         Add-VSTeamProfile -Account demonstrations -PersonalAccessToken 12345

         It 'Should save profile to disk' {
            Assert-VerifiableMocks
         }
      }

      Context 'Add-VSTeamProfile with PAT exisiting entry' {
         $expectedPath = "$HOME/profiles.json"
         Mock Set-Content { } -Verifiable -ParameterFilter { $Path -eq $expectedPath -and $Value -like "*https://demonstrations.visualstudio.com*" -and $Value -like "*https://mydemos.visualstudio.com*" }
         Mock Set-Content { }
         Mock Get-VSTeamProfile { return '[{"Name":"mydemos","URL":"https://mydemos.visualstudio.com","Type":"Pat","Pat":"12345"}]' | ConvertFrom-Json }

         Add-VSTeamProfile -Account demonstrations -PersonalAccessToken 12345

         It 'Should save profile to disk' {
            Assert-VerifiableMocks
         }
      }

      Context 'Add-VSTeamProfile with PAT replace exisiting entry' {
         $expectedPath = "$HOME/profiles.json"
         Mock Set-Content { } -Verifiable -ParameterFilter { $Path -eq $expectedPath -and $Value -like "*OjY3ODkxMA==*" -and $Value -like "*https://mydemos.visualstudio.com*" }
         Mock Set-Content { }
         Mock Get-VSTeamProfile { return '[{"Name":"mydemos","URL":"https://mydemos.visualstudio.com/","Type":"Pat","Pat":"12345"}]' | ConvertFrom-Json }

         Add-VSTeamProfile -Account mydemos -PersonalAccessToken 678910

         It 'Should save profile to disk' {
            Assert-VerifiableMocks
         }
      }

      Context 'Get-VSTeamProfile invalid profiles file' {
         Mock Test-Path { return $true }
         Mock Get-Content { return 'Not Valid JSON. This might happen if someone touches the file.' }

         $actual = Get-VSTeamProfile
      
         It 'Should return 0 profiles' {
            $actual.Count | Should be 0
         }
      }

      Context 'Get-VSTeamProfile no profiles' {
         Mock Test-Path { return $false }

         $actual = Get-VSTeamProfile
      
         It 'Should return 0 profiles' {
            $actual.Count | Should be 0
         }
      }

      Context 'Get-VSTeamProfile' {

$contents = @"
         [
            {
               "Name": "http://localhost:8080/tfs/defaultcollection",
               "URL": "http://localhost:8080/tfs/defaultcollection",
               "Pat": "",
               "Type": "OnPremise"
            },
            {
               "Name": "http://192.168.1.3:8080/tfs/defaultcollection",
               "URL": "http://192.168.1.3:8080/tfs/defaultcollection",
               "Pat": "OnE2cXpseHk0YXp3dHpzNXhubnpneXcyNXdkdmpwaWdiMmhyaGl3bTNjeDN5d296cjVqeXE=",
               "Type": "Pat"
            },
            {
               "Name": "demonstrations",
               "URL": "https://demonstrations.visualstudio.com",
               "Pat": "OndrejR0ZHpwbDM3bXUycGt5c3hmb3RwcWI2bG9sbHkzdzY2a2x5am13YWtkcXVwYmg0emE=",
               "Type": "Pat"
            }
         ]
"@
         Mock Test-Path { return $true }
         Mock Get-Content { return $contents }

         $actual = Get-VSTeamProfile
      
         It 'Should return 3 profiles' {
            $actual.Count | Should be 3
         }

         It '1st profile Should by OnPremise' {
            $actual[0].Type | Should be 'OnPremise'
         }
      }
   }
}