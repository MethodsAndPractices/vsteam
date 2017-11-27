Set-StrictMode -Version Latest

Get-Module Team | Remove-Module -Force
Get-Module Teams | Remove-Module -Force
Get-Module VSTeam | Remove-Module -Force
Get-Module Builds | Remove-Module -Force
Get-Module Projects | Remove-Module -Force
Get-Module Releases | Remove-Module -Force
Get-Module teamspsdrive | Remove-Module -Force

Import-Module SHiPS

Import-Module $PSScriptRoot\..\..\src\team.psm1 -Force
Import-Module $PSScriptRoot\..\..\src\teams.psm1 -Force
Import-Module $PSScriptRoot\..\..\src\builds.psm1 -Force
Import-Module $PSScriptRoot\..\..\src\projects.psm1 -Force
Import-Module $PSScriptRoot\..\..\src\releases.psm1 -Force
Import-Module $PSScriptRoot\..\..\src\teamspsdrive.psm1 -Force

InModuleScope teamspsdrive {
   Describe "TeamsPSDrive" {
      Mock Get-VSTeamProject { return [PSCustomObject]@{ 
            name        = 'Project' 
            id          = 1
            description = ''
         } 
      }

      Context 'VSAccount' {

         $target = [VSAccount]::new('TestAccount')

         It 'Should create VSAccount' {
            $target | Should Not Be $null
         }

         It 'Should return projects' {
            $target.GetChildItem() | Should Not Be $null
         }
      }

      Context 'Project' {

         $target = [Project]::new('TestProject', '123', '')

         It 'Should create Project' {
            $target | Should Not Be $null
         }

         It 'Should return builds, releases and teams' {
            $actual = $target.GetChildItem()
            $actual | Should Not Be $null
            $actual[0].Name | Should Be 'Builds'
            $actual[0].ProjectName | Should Be 'TestProject'
            $actual[1].Name | Should Be 'Releases'
            $actual[1].ProjectName | Should Be 'TestProject'
            $actual[2].Name | Should Be 'Teams'
            $actual[2].ProjectName | Should Be 'TestProject'
         }
      }

      
      Mock Get-VSTeamBuild { return [PSCustomObject]@{ 
            definition       = [PSCustomObject]@{fullname = 'BuildDef' }
            buildnumber      = ''
            status           = ''
            result           = ''
            starttime        = ''
            requestedByUser  = ''
            requestedForUser = ''
            projectname      = ''
            id               = 1
         } 
      }

      Context 'Builds' {

         $target = [Builds]::new('TestBuild', 'TestProject')

         It 'Should create Builds' {
            $target | Should Not Be $null
         }

         It 'Should return build' {
            $target.GetChildItem() | Should Not Be $null
         }
      }

      Context 'Build' {
         
         $target = [Build]::new('TestBuildDef', 'TestBuildNumber', 'TestBuildStatus', 'TestBuildResult', 'StartTime', 'TestUser', 'TestUser', 'TestProject', 1)
         
         It 'Should create Build' {
            $target | Should Not Be $null
         }
      }

      Mock Get-VSTeamRelease { return [PSCustomObject]@{ 
            Environments  = [PSCustomObject]@{
               status = [PSCustomObject]@{
                  environments = [PSCustomObject]@{
                     status = 'Succeeded'
                  } 
               }
            }
            name          = ''
            status        = ''
            createdByUser = ''
            createdOn     = ''
            id            = 1
         } 
      }

      Context 'Releases' {
         
         $target = [Releases]::new('TestReleasesName', 'TestProject')
         
         It 'Should create Releases' {
            $target | Should Not Be $null
         }

         It 'Should return release' {
            $target.GetChildItem() | Should Not Be $null
         }
      }

      Context 'Release' {
         
         $target = [Release]::new('TestReleaseId', 'TestReleaseName', 'TestReleaseStatus', 'TestUser', '1/1/2017', @())
         
         It 'Should create Release' {
            $target | Should Not Be $null
         }
      }

      Mock Get-VSTeam { return [PSCustomObject]@{             
            name        = ''
            ProjectName = ''
            description = ''
            id          = 1
         } 
      }

      Context 'Teams' {
         
         $target = [Teams]::new('TestTeamsName', 'TestProject')
         
         It 'Should create Teams' {
            $target | Should Not Be $null
         }

         It 'Should return team' {
            $target.GetChildItem() | Should Not Be $null
         }
      }

      Context 'Team' {
         
         $target = [Team]::new('TestTeamId', 'TestTeamName', 'TestProject', '')
         
         It 'Should create Team' {
            $target | Should Not Be $null
         }
      }
   }
}