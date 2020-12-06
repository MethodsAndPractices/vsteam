Set-StrictMode -Version Latest

Describe 'VSTeamDefaultProjectCount' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      Mock _getInstance { return 'https://dev.azure.com/test' }
   }

   Context 'Set-VSTeamDefaultProjectCount' {
      AfterAll {
         $env:TEAM_PROJECTCOUNT = $null
      }

      It 'should set default project' {
         Set-VSTeamDefaultProjectCount 500

         $env:TEAM_PROJECTCOUNT | Should -Be '500'
      }

      It 'should update default project' {
         $env:TEAM_PROJECTCOUNT = '100'

         Set-VSTeamDefaultProjectCount -Count 500

         $env:TEAM_PROJECTCOUNT | Should -Be '500'
      }
   }

   Context 'Set-VSTeamDefaultProjectCount on Non Windows' {
      BeforeAll {
         Mock _isOnWindows { return $false } -Verifiable
      }

      AfterAll {
         $env:TEAM_PROJECTCOUNT = $null
      }

      It 'should set default project' {
         Set-VSTeamDefaultProjectCount 700

         Should -InvokeVerifiable
         $env:TEAM_PROJECTCOUNT | Should -Be '700'
      }
   }

   Context 'Set-VSTeamDefaultProjectCount As Admin on Windows' {
      BeforeAll {
         Mock _isOnWindows { return $true }
         Mock _testAdministrator { return $true } -Verifiable
      }

      AfterAll {
         $env:TEAM_PROJECTCOUNT = $null
      }

      It 'should set default project' {
         Set-VSTeamDefaultProjectCount 450

         Should -InvokeVerifiable
         $env:TEAM_PROJECTCOUNT | Should -Be '450'
      }
   }
}