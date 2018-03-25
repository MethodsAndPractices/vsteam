Set-StrictMode -Version Latest

Get-Module VSTeam | Remove-Module -Force
Get-Module Team | Remove-Module -Force
Get-Module Git | Remove-Module -Force


Import-Module $PSScriptRoot\..\..\src\team.psm1 -Force
Import-Module $PSScriptRoot\..\..\src\git.psm1 -Force

InModuleScope git {
   
   # Set the account to use for testing. A normal user would do this
   # using the Add-VSTeamAccount function.
   $VSTeamVersionTable.Account = 'https://test.visualstudio.com'

   $results = [PSCustomObject]@{
      value = [PSCustomObject]@{ }
   }

   $singleResult = [PSCustomObject]@{ }

   Describe "Git VSTS" {

      Context 'Show-VSTeamGitRepository by project' {
         Mock _showInBrowser -Verifiable -ParameterFilter { $url -eq 'https://test.visualstudio.com/_git/project' }
         Mock _showInBrowser { throw "_showInBrowser called incorrectly: $Args" }

         Show-VSTeamGitRepository -projectName project

         it 'should return url for mine' {
            Assert-VerifiableMock
         }
      }

      Context 'Show-VSTeamGitRepository by remote url' {
         Mock _showInBrowser -Verifiable -ParameterFilter { $url -eq 'https://test.visualstudio.com/_git/project' }
         Mock _showInBrowser { throw "_showInBrowser called incorrectly: $Args" }

         Show-VSTeamGitRepository -RemoteUrl 'https://test.visualstudio.com/_git/project'

         it 'should return url for mine' {
            Assert-VerifiableMock
         }
      }

      Context 'Get-VSTeamGitRepository no parameters' {
         Mock Invoke-RestMethod { return $results } -Verifiable

         Get-VSTeamGitRepository

         It 'Should return all repos for all projects' {
            Assert-VerifiableMock
         }
      }

      Context 'Get-VSTeamGitRepository by id' {
         Mock Invoke-RestMethod { return $singleResult } -Verifiable

         Get-VSTeamGitRepository -id 00000000-0000-0000-0000-000000000000

         It 'Should return a single repo by id' {
            Assert-VerifiableMock
         }
      }

      Context 'Get-VSTeamGitRepository by name' {
         Mock Invoke-RestMethod { return $singleResult } -Verifiable

         Get-VSTeamGitRepository -Name 'test'

         It 'Should return a single repo by name' {
            Assert-VerifiableMock
         }
      }

      Context 'Remove-VSTeamGitRepository by id' {
         Mock Invoke-RestMethod

         Remove-VSTeamGitRepository -id 00000000-0000-0000-0000-000000000000 -Force

         It 'Should create VSAccount' {
            Assert-MockCalled Invoke-RestMethod -ParameterFilter {
               $Method -eq 'Delete' -and
               $Uri -eq "https://test.visualstudio.com/_apis/git/repositories/00000000-0000-0000-0000-000000000000?api-version=$($VSTeamVersionTable.Git)"
            }
         }
      }
   }

   Describe "Git TFS" {

      Mock _useWindowsAuthenticationOnPremise { return $true }
      
      $VSTeamVersionTable.Account = 'http://localhost:8080/tfs/defaultcollection'
      
      Context 'Get-VSTeamGitRepository no parameters' {
         Mock Invoke-RestMethod { return $results } -Verifiable
      
         Get-VSTeamGitRepository
      
         It 'Should create VSAccount' {
            Assert-VerifiableMock
         }
      }
      
      Context 'Get-VSTeamGitRepository by id' {
         Mock Invoke-RestMethod { return $singleResult } -Verifiable
      
         Get-VSTeamGitRepository -id 00000000-0000-0000-0000-000000000000
      
         It 'Should create VSAccount' {
            Assert-VerifiableMock
         }
      }
      
      Context 'Get-VSTeamGitRepository by name' {
         Mock Invoke-RestMethod { return $singleResult } -Verifiable
      
         Get-VSTeamGitRepository -Name 'test'
      
         It 'Should create VSAccount' {
            Assert-VerifiableMock
         }
      }

      Context 'Add-VSTeamGitRepository by name' {
         Mock Invoke-RestMethod { return $singleResult } -Verifiable
      
         Add-VSTeamGitRepository -Name 'test' -ProjectName 'test'
      
         It 'Should create VSAccount' {
            Assert-VerifiableMock
         }
      }
   }
}