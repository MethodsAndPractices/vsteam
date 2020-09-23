Set-StrictMode -Version Latest

Describe 'VSTeamProfile' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      # We have to do this here because you can't mock Get-Content then
      # try and call it to load a file.
      $contents = Get-Content "$sampleFiles/Get-VSTeamProfile.json" -Raw
   }

   Context 'Get-VSTeamProfile' {
      BeforeAll {
         Mock Get-Content { return '' }
         Mock Test-Path { return $true }
      }

      It 'empty profiles file should return 0 profiles' {
         $actual = Get-VSTeamProfile
         $actual | Should -BeNullOrEmpty
      }
   }

   Context 'Get-VSTeamProfile invalid profiles file' {
      BeforeAll {
         Mock Test-Path { return $true }
         Mock Write-Error { } -Verifiable
         Mock Get-Content { return 'Not Valid JSON. This might happen if someone touches the file.' }
      }

      It 'invalid profiles file should return 0 profiles' {
         $actual = Get-VSTeamProfile
         $actual | Should -BeNullOrEmpty
         Should -InvokeVerifiable
      }
   }

   Context 'Get-VSTeamProfile no profiles' {
      BeforeAll {
         Mock Test-Path { return $false }
         
         $actual = Get-VSTeamProfile
      }
      
      It 'no profiles should return 0 profiles' {
         $actual | Should -BeNullOrEmpty
      }
   }

   Context 'Get-VSTeamProfile by name' {
      BeforeAll {
         Mock Test-Path { return $true }
         Mock Get-Content { return $contents }
         
         $actual = Get-VSTeamProfile test
      }
      
      It 'by name should return 1 profile' {
         $actual.URL | Should -Be 'https://dev.azure.com/test'
      }

      It 'by name profile Should by Pat' {
         $actual.Type | Should -Be 'Pat'
      }

      It 'by name token Should be empty string' {
         # This is testing that the Token property is added
         # to existing profiles loaded from file created before
         # the bearer token support was added.
         $actual.Token | Should -Be ''
      }
   }

   Context 'Get-VSTeamProfile' {
      BeforeAll {
         Mock Test-Path { return $true }
         Mock Get-Content { return $contents }

         $actual = Get-VSTeamProfile
      }

      It 'Should return 3 profiles' {
         $actual.Length | Should -Be 3
      }

      It '1st profile Should by OnPremise' {
         $actual[0].Type | Should -Be 'OnPremise'
      }
   }

   Context 'Get-VSTeamProfile with old URL' {
      BeforeAll {
         Mock Test-Path { return $true }
         Mock Get-Content { return '[{"Name":"test","URL":"https://test.visualstudio.com","Type":"Pat","Pat":"12345","Version":"VSTS"}]' }

         $actual = Get-VSTeamProfile
      }

      It 'Should return new URL' {
         $actual.URL | Should -Be "https://dev.azure.com/test"
      }
   }

   Context 'Get-VSTeamProfile with old URL and multiple entries' {
      BeforeAll {
         Mock Test-Path { return $true }
         Mock Get-Content { return '[{"Name":"test","URL":"https://test.visualstudio.com","Type":"Pat","Pat":"12345","Version":"VSTS"},{"Name":"demo","URL":"https://demo.visualstudio.com","Type":"Pat","Pat":"12345","Version":"VSTS"}]' }

         $actual = Get-VSTeamProfile -Name "test"
      }

      It 'Should return new URL' {
         $actual.URL | Should -Be "https://dev.azure.com/test"
      }
   }
}