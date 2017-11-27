Set-StrictMode -Version Latest

Get-Module VSTeam | Remove-Module -Force
Import-Module $PSScriptRoot\..\..\src\team.psm1 -Force
Import-Module $PSScriptRoot\..\..\src\profile.psm1 -Force
Import-Module $PSScriptRoot\..\..\src\projects.psm1 -Force

Set-VSTeamAPIVersion -Version $env:API_VERSION

Describe 'Project' {
   BeforeAll {
      $pat = $env:PAT
      $acct = $env:ACCT
      $api = $env:API_VERSION

      Add-VSTeamAccount -a $acct -pe $pat -version $api
   }

   Context 'Full exercise' {
      It 'Add-VSTeamProject Should create project' {
         Add-VSTeamProject -ProjectName 'TeamModuleIntegration' | Should Not Be $null
      }

      It 'Get-VSTeamProject Should return projects' {
         Get-VSTeamProject -ProjectName 'TeamModuleIntegration'  | Should Not Be $null
      }

      It 'Update-VSTeamProject Should update description' {
         Update-VSTeamProject -ProjectName 'TeamModuleIntegration' -NewDescription 'Test Description' -Force

         Get-VSTeamProject -ProjectName 'TeamModuleIntegration' | Select-Object -ExpandProperty 'Description' | Should Be 'Test Description'
      }

      It 'Update-VSTeamProject Should update name' {
         Update-VSTeamProject -ProjectName 'TeamModuleIntegration' -NewName 'TeamModuleIntegration1' -Force

         Get-VSTeamProject -ProjectName 'TeamModuleIntegration1' | Select-Object -ExpandProperty 'Description' | Should Be 'Test Description'
      }

      It 'Remove-VSTeamProject Should delete project' {
         Remove-VSTeamProject -ProjectName 'TeamModuleIntegration1' -Force

         Get-VSTeamProject | Where-Object { $_.Name -eq 'TeamModuleIntegration1' } | Should Be $null
      }
   }

   AfterAll {
      Get-VSTeamProject | Remove-VSTeamProject -Force

      Remove-TeamAccount
   } 
}