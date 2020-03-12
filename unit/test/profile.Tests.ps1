Set-StrictMode -Version Latest

InModuleScope VSTeam {
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
            "URL": "https://dev.azure.com/test",
            "Pat": "OndrejR0ZHpwbDM3bXUycGt5c3hm",
            "Type": "Pat",
            "Version": "VSTS"
         }
      ]
"@

      Context 'Remove-VSTeamProfile' {
         Mock Set-Content {
            # If this test fails uncomment the line below to see how the mock was called.
            Write-Host $args
         } -Verifiable -ParameterFilter { $Path -eq $expectedPath -and [string]$Value -eq '' }
         Mock Set-Content { }
         Mock Get-VSTeamProfile { return '[{"Name":"test","URL":"https://dev.azure.com/test","Type":"Pat","Pat":"12345","Version":"VSTS"}]' | ConvertFrom-Json | ForEach-Object { $_ } }

         Remove-VSTeamProfile test

         It 'Should save profile to disk' {
            Assert-VerifiableMock
         }
      }

      Context 'Remove-VSTeamProfile entry does not exist' {
         Mock Set-Content { } -Verifiable -ParameterFilter { $Path -eq $expectedPath -and $Value -like "*https://dev.azure.com/test*" }
         Mock Set-Content { }
         Mock Get-VSTeamProfile { return '[{"Name":"test","URL":"https://dev.azure.com/test","Type":"Pat","Pat":"12345","Version":"VSTS"}]' | ConvertFrom-Json | ForEach-Object { $_ } }

         Remove-VSTeamProfile demos

         It 'Should save profile to disk' {
            Assert-VerifiableMock
         }
      }

      Context 'Add-VSTeamProfile on Windows no data provided' {
         Mock Set-Content { }
         Mock Write-Error { }
         Mock Get-VSTeamProfile { }
         Mock _isOnWindows { return $true }
         Mock _convertSecureStringTo_PlainText { return '' }

         $emptySecureString = ConvertTo-SecureString 'does not matter because mock is going to return empty string' -AsPlainText -Force

         Add-VSTeamProfile -Account testing -SecurePersonalAccessToken $emptySecureString

         It 'Should save profile to disk' {
            Assert-MockCalled Set-Content -Exactly -Scope Context -Times 0
            Assert-MockCalled Write-Error -Exactly -Scope Context -Times 1 `
               -ParameterFilter {
               $Message -eq 'Personal Access Token must be provided if you are not using Windows Authentication; please see the help.'
            }
         }
      }

      Context 'Add-VSTeamProfile with PAT to empty file' {
         Mock Set-Content { } -Verifiable -ParameterFilter { $Path -eq $expectedPath -and $Value -like "*https://dev.azure.com/demos*" -and $Value -like "*VSTS*" }
         Mock Set-Content { }
         Mock Get-VSTeamProfile { }

         Add-VSTeamProfile -Account demos -PersonalAccessToken 12345

         It 'Should save profile to disk' {
            Assert-VerifiableMock
         }
      }

      Context 'Add-VSTeamProfile with PAT to empty array' {
         Mock Set-Content { } -Verifiable -ParameterFilter { $Path -eq $expectedPath -and $Value -like "*https://dev.azure.com/demos*" -and $Value -like "*VSTS*" }
         Mock Set-Content { }
         Mock Get-VSTeamProfile { }

         Add-VSTeamProfile -Account demos -PersonalAccessToken 12345 -Version VSTS

         It 'Should save profile to disk' {
            Assert-VerifiableMock
         }
      }

      Context 'Add-VSTeamProfile with OAuth to empty array' {
         Mock Set-Content { } -Verifiable -ParameterFilter { $Path -eq $expectedPath -and $Value -like "*https://dev.azure.com/demos*" -and $Value -like "*VSTS*" }
         Mock Set-Content { }
         Mock Get-VSTeamProfile { }

         Add-VSTeamProfile -Account demos -PersonalAccessToken 12345 -Version VSTS -UseBearerToken

         It 'Should save profile to disk' {
            Assert-VerifiableMock
         }
      }

      Context 'Add-VSTeamProfile with PAT exisiting entry' {
         Mock Set-Content { } -Verifiable -ParameterFilter { $Path -eq $expectedPath -and $Value -like "*https://dev.azure.com/demos*" -and $Value -like "*https://dev.azure.com/test*" -and $Value -like "*TFS2018*" }
         Mock Set-Content { }
         Mock Get-VSTeamProfile { return '[{"Name":"test","URL":"https://dev.azure.com/test","Type":"Pat","Pat":"12345","Version":"VSTS"}]' | ConvertFrom-Json | ForEach-Object { $_ } }

         Add-VSTeamProfile -Account demos -PersonalAccessToken 12345 -Version TFS2018

         It 'Should save profile to disk' {
            Assert-VerifiableMock
         }
      }

      Context 'Add-VSTeamProfile TFS default to TFS2017 with Windows Auth' {
         Mock Set-Content { } -Verifiable -ParameterFilter { $Path -eq $expectedPath -and $Value -like "*OnPremise*" -and $Value -like "*http://localhost:8080/tfs/defaultcollection*" -and $Value -like "*TFS2017*" }
         Mock Set-Content { }
         Mock _isOnWindows { return $true }
         Mock Get-VSTeamProfile { return '[{"Name":"test","URL":"https://dev.azure.com/test/","Type":"Pat","Pat":"12345","Version":"VSTS"}]' | ConvertFrom-Json | ForEach-Object { $_ } }

         Add-VSTeamProfile -Account http://localhost:8080/tfs/defaultcollection -UseWindowsAuthentication

         It 'Should save profile to disk' {
            Assert-VerifiableMock
         }
      }

      Context 'Add-VSTeamProfile TFS default to TFS2017' {
         Mock Set-Content { } -Verifiable -ParameterFilter { $Path -eq $expectedPath -and $Value -like "*OjY3ODkxMA==*" -and $Value -like "*http://localhost:8080/tfs/defaultcollection*" -and $Value -like "*TFS2017*" }
         Mock Set-Content { }
         Mock Get-VSTeamProfile { return '[{"Name":"test","URL":"https://dev.azure.com/test/","Type":"Pat","Pat":"12345","Version":"VSTS"}]' | ConvertFrom-Json | ForEach-Object { $_ } }

         Add-VSTeamProfile -Account http://localhost:8080/tfs/defaultcollection -PersonalAccessToken 678910

         It 'Should save profile to disk' {
            Assert-VerifiableMock
         }
      }

      Context 'Add-VSTeamProfile with PAT replace exisiting entry' {
         Mock Set-Content { } -Verifiable -ParameterFilter { $Path -eq $expectedPath -and $Value -like "*OjY3ODkxMA==*" -and $Value -like "*https://dev.azure.com/test*" -and $Value -like "*VSTS*" }
         Mock Set-Content { }
         Mock Get-VSTeamProfile { return '[{"Name":"test","URL":"https://dev.azure.com/test/","Type":"Pat","Pat":"12345","Version":"VSTS"}]' | ConvertFrom-Json | ForEach-Object { $_ } }

         Add-VSTeamProfile -Account test -PersonalAccessToken 678910

         It 'Should save profile to disk' {
            Assert-VerifiableMock
         }
      }

      Context 'Add-VSTeamProfile with existing old URL' {
         Mock Test-Path { return $true }
         Mock Get-Content { return '[{"Name":"test","URL":"https://test.visualstudio.com","Type":"Pat","Pat":"12345","Version":"VSTS"}]' }
         Mock Set-Content { } -Verifiable -ParameterFilter { $Path -eq $expectedPath -and $Value -like "*OjY3ODkxMA==*" -and $Value -like "*https://dev.azure.com/test*" -and $Value -like "*VSTS*" }
         Mock Set-Content { }

         Add-VSTeamProfile -Account test -PersonalAccessToken 678910

         It 'Should save profile with new URL to disk' {
            Assert-VerifiableMock
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
            Assert-VerifiableMock
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
            $actual.URL | Should be 'https://dev.azure.com/test'
         }

         It 'Profile Should by Pat' {
            $actual.Type | Should be 'Pat'
         }

         It 'Token Should be empty string' {
            # This is testing that the Token property is added
            # to existing profiles loaded from file created before
            # the bearer token support was added.
            $actual.Token | Should be ''
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

      Context 'Get-VSTeamProfile with old URL' {
         Mock Test-Path { return $true }
         Mock Get-Content { return '[{"Name":"test","URL":"https://test.visualstudio.com","Type":"Pat","Pat":"12345","Version":"VSTS"}]' }

         $actual = Get-VSTeamProfile

         It 'Should return new URL' {
            $actual.URL | Should Be "https://dev.azure.com/test"
         }
      }

      Context 'Get-VSTeamProfile with old URL and multiple entries' {
         Mock Test-Path { return $true }
         Mock Get-Content { return '[{"Name":"test","URL":"https://test.visualstudio.com","Type":"Pat","Pat":"12345","Version":"VSTS"},{"Name":"demo","URL":"https://demo.visualstudio.com","Type":"Pat","Pat":"12345","Version":"VSTS"}]' }

         $actual = Get-VSTeamProfile -Name "test"

         It 'Should return new URL' {
            $actual.URL | Should Be "https://dev.azure.com/test"
         }
      }

      Context 'Update-VSTeamProfile entry does not exist' {
         Mock Get-VSTeamProfile { return '[{"Name":"test","URL":"https://dev.azure.com/test","Type":"Pat","Pat":"12345","Version":"VSTS"}]' | ConvertFrom-Json | ForEach-Object { $_ } }

         It 'Should throw' {
            { Update-VSTeamProfile -Name Testing -PersonalAccessToken 678910 } | Should -Throw
         }
      }

      Context 'Update-VSTeamProfile with PAT to empty file' {
         Mock Set-Content { }
         Mock Write-Warning -Verifiable
         Mock Get-VSTeamProfile { }

         Update-VSTeamProfile -name demos -PersonalAccessToken 12345

         It 'Should save profile to disk' {
            Assert-VerifiableMock
         }
      }

      Context 'Update-VSTeamProfile with securePersonalAccessToken' {
         Mock Set-Content { } -Verifiable -ParameterFilter { $Path -eq $expectedPath -and $Value -like "*OjY3ODkxMA==*" -and $Value -like "*https://dev.azure.com/test*" -and $Value -like "*VSTS*" }
         Mock Set-Content { }
         Mock Get-VSTeamProfile { return '[{"Name":"test","URL":"https://dev.azure.com/test/","Type":"Pat","Pat":"12345","Version":"VSTS"}]' | ConvertFrom-Json | ForEach-Object { $_ } }

         $password = '678910' | ConvertTo-SecureString -AsPlainText -Force

         Update-VSTeamProfile -Name test -SecurePersonalAccessToken $password

         It 'Should update profile' {
            Assert-VerifiableMock
         }
      }

      Context 'Update-VSTeamProfile with PAT' {
         Mock Set-Content { } -Verifiable -ParameterFilter { $Path -eq $expectedPath -and $Value -like "*OjY3ODkxMA==*" -and $Value -like "*https://dev.azure.com/test*" -and $Value -like "*VSTS*" }
         Mock Set-Content { }
         Mock Get-VSTeamProfile { return '[{"Name":"test","URL":"https://dev.azure.com/test/","Type":"Pat","Pat":"12345","Version":"VSTS"}]' | ConvertFrom-Json | ForEach-Object { $_ } }

         Update-VSTeamProfile -Name test -PersonalAccessToken 678910

         It 'Should update profile' {
            Assert-VerifiableMock
         }
      }

      Context 'Update-VSTeamProfile with old URL' {
         Mock Test-Path { return $true }
         Mock Get-Content { return '[{"Name":"test","URL":"https://test.visualstudio.com","Type":"Pat","Pat":"12345","Version":"VSTS"}]' }
         Mock Set-Content { } -Verifiable -ParameterFilter { $Path -eq $expectedPath -and $Value -like "*OjY3ODkxMA==*" -and $Value -like "*https://dev.azure.com/test*" -and $Value -like "*VSTS*" }
         Mock Set-Content { }

         Update-VSTeamProfile -Name test -PersonalAccessToken 678910

         It 'Should update profile with new URL' {
            Assert-VerifiableMock
         }
      }


   }
}