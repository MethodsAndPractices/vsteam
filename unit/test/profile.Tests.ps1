Set-StrictMode -Version Latest

Get-Module team | Remove-Module -Force
Import-Module $PSScriptRoot\..\..\src\profile.psm1 -Force

InModuleScope profile {
   Describe 'Profile' {
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

      Context 'Remove-VSTeamProfile' {
         $expectedPath = "$HOME/profiles.json"
         Mock Set-Content { } -Verifiable -ParameterFilter { $Path -eq $expectedPath -and [string]$Value -eq '' }
         Mock Set-Content { }
         Mock Get-VSTeamProfile { return '[{"Name":"mydemos","URL":"https://mydemos.visualstudio.com","Type":"Pat","Pat":"12345"}]' | ConvertFrom-Json | ForEach-Object { $_ } }

         Remove-VSTeamProfile mydemos

         It 'Should save profile to disk' {
            Assert-VerifiableMocks
         }
      }

      Context 'Remove-VSTeamProfile entry does not exist' {
         $expectedPath = "$HOME/profiles.json"
         Mock Set-Content { } -Verifiable -ParameterFilter { $Path -eq $expectedPath -and $Value -like "*https://mydemos.visualstudio.com*" }
         Mock Set-Content { }
         Mock Get-VSTeamProfile { return '[{"Name":"mydemos","URL":"https://mydemos.visualstudio.com","Type":"Pat","Pat":"12345"}]' | ConvertFrom-Json | ForEach-Object { $_ } }

         Remove-VSTeamProfile demonstrations

         It 'Should save profile to disk' {
            Assert-VerifiableMocks
         }
      }

      Context 'Add-VSTeamProfile with PAT to empty file' {
         $expectedPath = "$HOME/profiles.json"
         Mock Set-Content { } -Verifiable -ParameterFilter { $Path -eq $expectedPath -and $Value -like "*https://demonstrations.visualstudio.com*" }
         Mock Set-Content { }
         Mock Get-VSTeamProfile { }

         Add-VSTeamProfile -Account demonstrations -PersonalAccessToken 12345

         It 'Should save profile to disk' {
            Assert-VerifiableMocks
         }
      }

      Context 'Add-VSTeamProfile with PAT to empty array' {
         $expectedPath = "$HOME/profiles.json"
         Mock Set-Content { } -Verifiable -ParameterFilter { $Path -eq $expectedPath -and $Value -like "*https://demonstrations.visualstudio.com*" }
         Mock Set-Content { }
         Mock Get-VSTeamProfile { }

         Add-VSTeamProfile -Account demonstrations -PersonalAccessToken 12345

         It 'Should save profile to disk' {
            Assert-VerifiableMocks
         }
      }

      Context 'Add-VSTeamProfile with PAT exisiting entry' {
         $expectedPath = "$HOME/profiles.json"
         Mock Set-Content { } -Verifiable -ParameterFilter { $Path -eq $expectedPath -and $Value -like "*https://demonstrations.visualstudio.com*" -and $Value -like "*https://mydemos.visualstudio.com*" }
         Mock Set-Content { }
         Mock Get-VSTeamProfile { return '[{"Name":"mydemos","URL":"https://mydemos.visualstudio.com","Type":"Pat","Pat":"12345"}]' | ConvertFrom-Json | ForEach-Object { $_ } }

         Add-VSTeamProfile -Account demonstrations -PersonalAccessToken 12345

         It 'Should save profile to disk' {
            Assert-VerifiableMocks
         }
      }

      Context 'Add-VSTeamProfile with PAT replace exisiting entry' {
         $expectedPath = "$HOME/profiles.json"
         Mock Set-Content { } -Verifiable -ParameterFilter { $Path -eq $expectedPath -and $Value -like "*OjY3ODkxMA==*" -and $Value -like "*https://mydemos.visualstudio.com*" }
         Mock Set-Content { }
         Mock Get-VSTeamProfile { return '[{"Name":"mydemos","URL":"https://mydemos.visualstudio.com/","Type":"Pat","Pat":"12345"}]' | ConvertFrom-Json | ForEach-Object { $_ } }

         Add-VSTeamProfile -Account mydemos -PersonalAccessToken 678910

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

         $actual = Get-VSTeamProfile
      
         It 'Should return 0 profiles' {
            $actual | Should BeNullOrEmpty
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
         
         $actual = Get-VSTeamProfile demonstrations
               
         It 'Should return 1 profile' {
            $actual.URL | Should be 'https://demonstrations.visualstudio.com'
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