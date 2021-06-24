Set-StrictMode -Version Latest

Describe 'VSTeamUserPRofile' -Tag 'unit', 'profile' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      Mock _getInstance { return 'https://dev.azure.com' }

      Mock Invoke-RestMethod { return $null }
   }

   Context 'Get-VSTeamUserProfile' {
      It 'should get my profile' {
         Get-VSTeamUserProfile -MyProfile

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 `
            -ParameterFilter {
            $Method -eq 'Get' -and
            $Uri -eq "https://vssps.dev.azure.com/_apis/profile/profiles/me?api-version=3.0"
         }
      }

      It 'should get profile by id' {
         Get-VSTeamUserProfile -Id 1e9ff4fe-2db1-44e9-81d0-0ecf9eee7f86

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 `
            -ParameterFilter {
            $Method -eq 'Get' -and
            $Uri -eq "https://vssps.dev.azure.com/_apis/profile/profiles/1e9ff4fe-2db1-44e9-81d0-0ecf9eee7f86?api-version=3.0"
         }
      }
   }
}
