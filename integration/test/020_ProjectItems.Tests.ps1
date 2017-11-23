Set-StrictMode -Version Latest

Get-Module team | Remove-Module -Force
Import-Module $PSScriptRoot\..\..\src\team.psm1 -Force
Import-Module $PSScriptRoot\..\..\src\profile.psm1 -Force
Import-Module $PSScriptRoot\..\..\src\projects.psm1 -Force
Import-Module $PSScriptRoot\..\..\src\git.psm1 -Force
Import-Module $PSScriptRoot\..\..\src\pools.psm1 -Force
Import-Module $PSScriptRoot\..\..\src\Queues.psm1 -Force
Import-Module $PSScriptRoot\..\..\src\teams.psm1 -Force
Import-Module $PSScriptRoot\..\..\src\teammembers.psm1 -Force

Set-VSTeamAPIVersion -Version $env:API_VERSION

Describe 'Project Items' {
   BeforeAll {
      $pat = $env:PAT
      $acct = $env:ACCT
      $api = $env:API_VERSION
      
      Add-VSTeamAccount -a $acct -pe $pat -version $api
      Add-VSTeamProject -ProjectName 'TeamModuleIntegration'
   }

   Context 'Git Full exercise' {
      It 'Get-VSTeamGitRepository Should return repository' {
         Get-VSTeamGitRepository -ProjectName 'TeamModuleIntegration' | Select-Object -ExpandProperty Name | Should Be 'TeamModuleIntegration'
      }

      It 'Add-VSTeamGitRepository Should create repository' {
         Add-VSTeamGitRepository -ProjectName 'TeamModuleIntegration' -Name 'testing'
         (Get-VSTeamGitRepository -ProjectName 'TeamModuleIntegration').Count | Should Be 2
         Get-VSTeamGitRepository -ProjectName 'TeamModuleIntegration' -Name 'testing' | Select-Object -ExpandProperty Name | Should Be 'testing'
      }

      It 'Remove-VSTeamGitRepository Should delete repository' {
         Get-VSTeamGitRepository -ProjectName 'TeamModuleIntegration' -Name 'testing' | Select-Object -ExpandProperty Id | Remove-VSTeamGitRepository -Force
         Get-VSTeamGitRepository -ProjectName 'TeamModuleIntegration' | Where-Object { $_.Name -eq 'testing' } | Should Be $null
      }
   }

   Context 'Pool Full exercise' {
      It 'Get-VSTeamPool Should return agent pools' {
         $actual = Get-VSTeamPool

         if ($acct -like "http://*") {
            $actual.name | Should Be 'Default'
         }
         else {
            $actual.Count | Should Be 5
         }
      }
   }

   Context 'Queue Full exercise' {
      It 'Get-VSTeamQueue Should return agent Queues' {
         $actual = Get-VSTeamQueue -ProjectName 'TeamModuleIntegration'

         if ($acct -like "http://*") {
            $actual.name | Should Be 'Default'
         }
         else {
            $actual.Count | Should Be 5
         }
      }
   }

   Context 'Teams Full exercise' {
      It 'Get-VSTeam ByName Should return Teams' {
         Get-VSTeam -ProjectName 'TeamModuleIntegration' -Name 'TeamModuleIntegration Team' | Should Not Be $null
      }

      It 'Get-VSTeam ById Should return Teams' {
         $id = (Get-VSTeam -ProjectName 'TeamModuleIntegration').Id
         Get-VSTeam -ProjectName 'TeamModuleIntegration' -Id $id | Should Not Be $null
      }

      It 'Add-VSTeam should add a team' {
         Add-VSTeam -ProjectName 'TeamModuleIntegration' -Name 'testing' | Should Not Be $null
         (Get-VSTeam -ProjectName 'TeamModuleIntegration').Count | Should Be 2
      }

      It 'Update-VSTeam should update a team' {
         Update-VSTeam -ProjectName 'TeamModuleIntegration' -Name 'testing' -NewTeamName 'testing123'
         Get-VSTeam -ProjectName 'TeamModuleIntegration' -Name 'testing123' | Should Not Be $null
      }

      It 'Remove-VSTeam should delete the team' {
         Remove-VSTeam -ProjectName 'TeamModuleIntegration' -Name 'testing123' -Force
         Get-VSTeam -ProjectName 'TeamModuleIntegration' | Where-Object { $_.Name -eq 'testing123'} | Should Be $null
      }
   }

   AfterAll {
      Get-VSTeamProject | Remove-VSTeamProject -Force

      Remove-TeamAccount
   } 
}