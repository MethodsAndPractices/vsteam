Set-StrictMode -Version Latest

Get-Module VSTeam | Remove-Module -Force

Import-Module SHiPS
Import-Module $PSScriptRoot\..\..\src\teamspsdrive.psm1 -Force

InModuleScope teamspsdrive {
   Describe "TeamsPSDrive" {

      Context 'VSAccount' {

         $target = [VSAccount]::new('TestAccount')

         It 'Should create VSAccount' {
            $target | Should Not Be $null
         }
      }

      Context 'Project' {
         
         $target = [Project]::new('TestProject', '123', '')
         
         It 'Should create Project' {
            $target | Should Not Be $null
         }
      }

      Context 'Builds' {
         
         $target = [Builds]::new('TestBuild', 'TestProject')
         
         It 'Should create Builds' {
            $target | Should Not Be $null
         }
      }
   }
}