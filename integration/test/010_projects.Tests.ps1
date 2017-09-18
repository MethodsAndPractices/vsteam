Set-StrictMode -Version Latest

Get-Module team | Remove-Module -Force
Import-Module $PSScriptRoot\..\..\src\team.psm1 -Force
Import-Module $PSScriptRoot\..\..\src\projects.psm1 -Force

Describe 'Project' {
   BeforeAll {
      $pat = $env:PAT
      $acct = $env:ACCT

      Add-TeamAccount -a $acct -pe $pat
   }

   Context 'Full exercise' {
      It 'Add-Project Should create project' {
         Add-Project -ProjectName 'TeamModuleIntegration' | Should Not Be $null
      }

      It 'Get-Project Should return projects' {
         Get-Project -ProjectName 'TeamModuleIntegration'  | Should Not Be $null
      }

      It 'Update-Project Should update description' {
         Update-Project -ProjectName 'TeamModuleIntegration' -NewDescription 'Test Description'

         Get-Project -ProjectName 'TeamModuleIntegration' | Select-Object -ExpandProperty 'Description' | Should Be 'Test Description'
      }

      It 'Update-Project Should update name' {
         Update-Project -ProjectName 'TeamModuleIntegration' -NewName 'TeamModuleIntegration1'

         Get-Project -ProjectName 'TeamModuleIntegration1' | Select-Object -ExpandProperty 'Description' | Should Be 'Test Description'
      }

      It 'Remove-Project Should delete project' {
         Remove-Project -ProjectName 'TeamModuleIntegration1' -Force

         Get-Project | Where-Object { $_.Name -eq 'TeamModuleIntegration1' } | Should Be $null
      }
   }

   AfterAll {
      Get-Project | Remove-Project -Force

      Remove-TeamAccount
   } 
}