Set-StrictMode -Version Latest

Get-Module team | Remove-Module -Force
Import-Module $PSScriptRoot\..\..\src\team.psm1 -Force
Import-Module $PSScriptRoot\..\..\src\projects.psm1 -Force
Import-Module $PSScriptRoot\..\..\src\git.psm1 -Force
Import-Module $PSScriptRoot\..\..\src\pools.psm1 -Force
Import-Module $PSScriptRoot\..\..\src\Queues.psm1 -Force
Import-Module $PSScriptRoot\..\..\src\teams.psm1 -Force

Describe 'Project Items' {
   BeforeAll {
      $pat = $env:PAT
      $acct = $env:ACCT

      Add-TeamAccount -a $acct -pe $pat
      Add-Project -ProjectName 'TeamModuleIntegration'
   }

   Context 'Git Full exercise' {
      It 'Get-GitRepository Should return repository' {
         Get-GitRepository -ProjectName 'TeamModuleIntegration' | Select-Object -ExpandProperty Name | Should Be 'TeamModuleIntegration'
      }

      It 'Add-GitRepository Should create repository' {
         Add-GitRepository -ProjectName 'TeamModuleIntegration' -Name 'testing'
         (Get-GitRepository -ProjectName 'TeamModuleIntegration').Count | Should Be 2
         Get-GitRepository -ProjectName 'TeamModuleIntegration' -Name 'testing' | Select-Object -ExpandProperty Name | Should Be 'testing'
      }

      It 'Remove-GitRepository Should delete repository' {
         Get-GitRepository -ProjectName 'TeamModuleIntegration' -Name 'testing' | Select-Object -ExpandProperty Id | Remove-GitRepository -Force
         Get-GitRepository -ProjectName 'TeamModuleIntegration' | Where-Object { $_.Name -eq 'testing' } | Should Be $null
      }
   }

   Context 'Pool Full exercise' {
      It 'Get-Pool Should return agent pools' {
         (Get-Pool).Count | Should Be 4
      }
   }

   Context 'Queue Full exercise' {
      It 'Get-Queue Should return agent Queues' {
         (Get-Queue -ProjectName 'TeamModuleIntegration').Count | Should Be 4
      }
   }

   Context 'Teams Full exercise' {
      It 'Get-Team ByName Should return Teams' {
         Get-Team -ProjectName 'TeamModuleIntegration' -Name 'TeamModuleIntegration Team' | Should Not Be $null
      }

      It 'Get-Team ById Should return Teams' {
         $id = (Get-Team -ProjectName 'TeamModuleIntegration').Id
         Get-Team -ProjectName 'TeamModuleIntegration' -TeamId $id | Should Not Be $null
      }

      It 'Add-Team should add a team' {
         Add-Team -ProjectName 'TeamModuleIntegration' -TeamName 'testing' | Should Not Be $null
         (Get-Team -ProjectName 'TeamModuleIntegration').Count | Should Be 2
      }
   }

   AfterAll {
      Get-Project | Remove-Project -Force

      Remove-TeamAccount
   } 
}