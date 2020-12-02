Set-StrictMode -Version Latest

Describe 'VSTeamDefaultProjectCount' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      Mock _getInstance { return 'https://dev.azure.com/test' }
   }

   Context 'Clear-VSTeamDefaultProjectCount on Non Windows' {
      BeforeAll {
         Mock _isOnWindows { return $false }
      }

      AfterAll {
         $env:TEAM_PROJECTCOUNT = $null
      }

      It 'should clear default project' {
         $env:TEAM_PROJECTCOUNT = "500"

         Clear-VSTeamDefaultProjectCount

         $env:TEAM_PROJECTCOUNT | Should -BeNullOrEmpty
      }
   }

   Context 'Clear-VSTeamDefaultProjectCount as Non-Admin on Windows' {
      BeforeAll {
         Mock _isOnWindows { return $true }
         Mock _testAdministrator { return $false }
      }

      AfterAll {
         $env:TEAM_PROJECTCOUNT = $null
      }

      It 'should clear default project' {
         $env:TEAM_PROJECTCOUNT = "500"

         Clear-VSTeamDefaultProjectCount

         $env:TEAM_PROJECTCOUNT | Should -BeNullOrEmpty
      }
   }

   Context 'Clear-VSTeamDefaultProjectCount as Admin on Windows' {
      BeforeAll {
         Mock _isOnWindows { return $true }
         Mock _testAdministrator { return $true }
      }

      AfterAll {
         $env:TEAM_PROJECTCOUNT = $null
      }

      It 'should clear default project' {
         $env:TEAM_PROJECTCOUNT = "500"

         Clear-VSTeamDefaultProjectCount

         $env:TEAM_PROJECTCOUNT | Should -BeNullOrEmpty
      }
   }
}