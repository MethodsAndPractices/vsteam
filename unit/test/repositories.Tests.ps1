Set-StrictMode -Version Latest

Get-Module VSTeam | Remove-Module -Force
Get-Module Team | Remove-Module -Force
Get-Module Repositories | Remove-Module -Force


Import-Module $PSScriptRoot\..\..\src\team.psm1 -Force
Import-Module $PSScriptRoot\..\..\src\repositories.psm1 -Force

InModuleScope repositories {

   # Set the account to use for testing. A normal user would do this
   # using the Add-VSTeamAccount function.
   $VSTeamVersionTable.Account = 'https://test.visualstudio.com'

   $results = [PSCustomObject]@{
      value = [PSCustomObject]@{
         id            = ''
         url           = ''
         sshUrl        = ''
         remoteUrl     = ''
         defaultBranch = ''
         size          = 0
         name          = ''
         project       = [PSCustomObject]@{
            name        = 'Project'
            id          = 1
            description = ''
            url         = ''
            state       = ''
            revision    = ''
            visibility  = ''
         }
      }
   }

   $singleResult = [PSCustomObject]@{
      id            = ''
      url           = ''
      sshUrl        = ''
      remoteUrl     = ''
      defaultBranch = ''
      size          = 0
      name          = ''
      project       = [PSCustomObject]@{
         name        = 'Project'
         id          = 1
         description = ''
         url         = ''
         state       = ''
         revision    = ''
         visibility  = ''
      }
   }

   Describe "Git VSTS" {
      . "$PSScriptRoot\mockProjectNameDynamicParam.ps1"
      . "$PSScriptRoot\..\..\src\teamspsdrive.ps1"

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

      Context 'Get-VSTeamGitRepository no parameters throws' {
         Mock Invoke-RestMethod { throw [System.Net.WebException] "Test Exception." }

         It 'Should return all repos for all projects' {
            { Get-VSTeamGitRepository } | Should Throw
         }
      }

      Context 'Get-VSTeamGitRepository by id' {
         Mock Invoke-RestMethod { return $singleResult } -Verifiable

         Get-VSTeamGitRepository -id 00000000-0000-0000-0000-000000000000

         It 'Should return a single repo by id' {
            Assert-VerifiableMock
         }
      }

      Context 'Get-VSTeamGitRepository by id throws' {
         Mock Invoke-RestMethod { throw [System.Net.WebException] "Test Exception." }

         It 'Should return a single repo by id' {
            { Get-VSTeamGitRepository -id 00000000-0000-0000-0000-000000000000 } | Should Throw
         }
      }

      Context 'Get-VSTeamGitRepository by name' {
         Mock Invoke-RestMethod { return $singleResult } -Verifiable

         Get-VSTeamGitRepository -Name 'test'

         It 'Should return a single repo by name' {
            Assert-VerifiableMock
         }
      }

      Context 'Get-VSTeamGitRepository by name throws' {
         Mock Invoke-RestMethod { throw [System.Net.WebException] "Test Exception." }

         It 'Should return a single repo by name' {
            { Get-VSTeamGitRepository -Name 'test' } | Should Throw
         }
      }

      Context 'Remove-VSTeamGitRepository by id' {
         Mock Invoke-RestMethod

         Remove-VSTeamGitRepository -id 00000000-0000-0000-0000-000000000000 -Force

         It 'Should remove Git repo' {
            Assert-MockCalled Invoke-RestMethod -ParameterFilter {
               $Method -eq 'Delete' -and
               $Uri -eq "https://test.visualstudio.com/_apis/git/repositories/00000000-0000-0000-0000-000000000000?api-version=$($VSTeamVersionTable.Git)"
            }
         }
      }

      Context 'Remove-VSTeamGitRepository throws ' {
         Mock Invoke-RestMethod { throw [System.Net.WebException] "Test Exception." }

         It 'Should throw trying to remove Git repo' {
            {Remove-VSTeamGitRepository -id 00000000-0000-0000-0000-000000000000 -Force} | Should Throw
         }
      }
   }

   Describe "Git TFS" {

      Mock _useWindowsAuthenticationOnPremise { return $true }
      . "$PSScriptRoot\..\..\src\teamspsdrive.ps1"

      $VSTeamVersionTable.Account = 'http://localhost:8080/tfs/defaultcollection'

      Context 'Get-VSTeamGitRepository no parameters' {
         Mock Invoke-RestMethod { return $results } -Verifiable

         Get-VSTeamGitRepository

         It 'Should return Git repo' {
            Assert-VerifiableMock
         }
      }

      Context 'Get-VSTeamGitRepository by id' {
         Mock Invoke-RestMethod { return $singleResult } -Verifiable

         Get-VSTeamGitRepository -id 00000000-0000-0000-0000-000000000000

         It 'Should return Git repo' {
            Assert-VerifiableMock
         }
      }

      Context 'Get-VSTeamGitRepository by name' {
         Mock Invoke-RestMethod { return $singleResult } -Verifiable

         Get-VSTeamGitRepository -Name 'test'

         It 'Should return Git repo' {
            Assert-VerifiableMock
         }
      }

      Context 'Add-VSTeamGitRepository by name' {
         Mock Invoke-RestMethod { return $singleResult } -Verifiable

         Add-VSTeamGitRepository -Name 'test' -ProjectName 'test'

         It 'Should add Git repo' {
            Assert-VerifiableMock
         }
      }

      Context 'Add-VSTeamGitRepository throws' {
         Mock Invoke-RestMethod { throw [System.Net.WebException] "Test Exception." }

         It 'Should add Git repo' {
            { Add-VSTeamGitRepository -Name 'test' -ProjectName 'test' } | Should Throw
         }
      }
   }
}