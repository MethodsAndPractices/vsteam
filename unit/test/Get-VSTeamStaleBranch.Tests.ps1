Set-StrictMode -Version Latest

InModuleScope VSTeam {

   # Set the account to use for testing. A normal user would do this
   # using the Set-VSTeamAccount function.
   [VSTeamVersions]::Account = 'https://dev.azure.com/test'

   $results = [PSCustomObject]@{
      Branch = [PSCustomObject]@{
         objectId = '6f365a7143e492e911c341451a734401bcacadfd'
         name     = 'refs/heads/master'
         creator  = [PSCustomObject]@{
            displayName = 'Microsoft.VisualStudio.Services.TFS'
            id          = '1'
            uniqueName  = 'some@email.com'
         }
      }
      Creator = [PSCustomObject]@{
         displayName = 'Microsoft.VisualStudio.Services.TFS'
         id          = '1'
         uniqueName  = 'some@email.com'
      }
      CreationDate = "1010101"
      ProjectName = "Test"
      Repository = "repo"
      LastCommit = "Block-SmbShareAccess"
      LastCommitter = [PSCustomObject]@{
         displayName = 'Microsoft.VisualStudio.Services.TFS'
         id          = '1'
         uniqueName  = 'some@email.com'
      }
   }

   $singleRepository = [VSTeamGitRepository]::new([PSCustomObject]@{
      id            = '00000000-0000-0000-0000-000000000000'
      url           = ''
      sshUrl        = ''
      remoteUrl     = ''
      defaultBranch = ''
      size          = 0
      name          = 'TestRepo'
      project       = [PSCustomObject]@{
         name        = 'Project'
         id          = 1
         description = ''
         url         = ''
         state       = ''
         revision    = ''
         visibility  = ''
      }
   }, "Project")

   $refs = @([VSTeamRef]::new([PSCustomObject]@{
      objectId = '6f365a7143e492e911c341451a734401bcacadfd'
      name     = 'refs/heads/master'
      creator  = [PSCustomObject]@{
         displayName = 'Microsoft.VisualStudio.Services.TFS'
         id          = '1'
         uniqueName  = 'some@email.com'
      }
   }, "Project"))

   $commits = @(
      [VSTeamGitCommitRef]::new(
         [PSCustomObject]@{
            author = [PSCustomObject]@{
               date = '2019-02-19T15:12:01Z'
               email = 'test@test.com'
               name = 'Test User'
            }
            changeCounts = [PSCustomObject]@{
               Add = 2
               Delete = 0
               Edit = 1
            }
            comment = 'Just a test commit'
            commitId = '1234567890abcdef1234567890abcdef'
            committer = [PSCustomObject]@{
               date = '2019-02-19T15:12:01Z'
               email = 'test@test.com'
               name = 'Test User'
            }
            remoteUrl = 'https://dev.azure.com/test/test/_git/test/commit/1234567890abcdef1234567890abcdef'
            url = 'https://dev.azure.com/test/21AF684D-AFFB-4F9A-9D49-866EF24D6A4A/_apid/git/repositories/06E176BE-D3D2-41C2-AB34-5F4D79AEC86B/commits/1234567890abcdef1234567890abcdef'
         }, "Project"),
      [VSTeamGitCommitRef]::new(
         [PSCustomObject]@{
            author = [PSCustomObject]@{
               date = '2019-02-20T01:00:01Z'
               email = 'eample@example.com'
               name = 'Example User'
            }
            changeCounts = [PSCustomObject]@{
               Add = 8
               Delete = 1
               Edit = 0
            }
            comment = 'Just another test commit'
            commitId = 'abcdef1234567890abcdef1234567890'
            committer = [PSCustomObject]@{
               date = '2019-02-20T01:00:01Z'
               email = 'eample@example.com'
               name = 'Example User'
            }
            remoteUrl = 'https://dev.azure.com/test/test/_git/test/commit/abcdef1234567890abcdef1234567890'
            url = 'https://dev.azure.com/test/21AF684D-AFFB-4F9A-9D49-866EF24D6A4A/_apid/git/repositories/06E176BE-D3D2-41C2-AB34-5F4D79AEC86B/commits/abcdef1234567890abcdef1234567890'
         }, "Project")
      )

      $stats = [PSCustomObject]@{
         commit = [PSCustomObject]@{
            commitId = '67cae2b029dff7eb3dc062b49403aaedca5bad8d'
            author = [PSCustomObject]@{
               name = '"Chuck Reinhart'
               email = 'fabrikamfiber3@hotmail.com'
               date = '2014-01-29T23:52:56Z'
            }
            committer = [PSCustomObject]@{
               name = '"Chuck Reinhart'
               email = 'fabrikamfiber3@hotmail.com'
               date = '2014-01-29T23:52:56Z'
            }
            comment = 'home page'
            url = 'https://dev.azure.com/fabrikam/_apis/git/repositories/278d5cd2-584d-4b63-824a-2ba458937249/commits/67cae2b029dff7eb3dc062b49403aaedca5bad8d'
         }
         name = 'develop'
         aheadCount = 1
         behindCount = 17
         isBaseVersion = $false
      }

      _applyTypes $stats "VSTeam.GitStat"

      Describe "Git VSTS" {
      # Mock the call to Get-Projects by the dynamic parameter for ProjectName
      Mock Invoke-RestMethod { return @() } -ParameterFilter {
         $Uri -like "*_apis/projects*"
      }

      . "$PSScriptRoot\mocks\mockProjectNameDynamicParam.ps1"

      Context 'Get-VSTeamStaleBranch' {
         Mock Get-VSTeamGitRepository { return $singleRepository } -ParameterFilter { $Id -eq "00000000-0000-0000-0000-000000000000" } -Verifiable
         Mock Get-VSTeamGitRef { return $refs } -Verifiable
         Mock Get-VSTeamGitCommit { return $commits } -Verifiable
         Mock Get-VSTeamGitStat { return $stats } -Verifiable

         $staleBranches = Get-VSTeamStaleBranch -ProjectName Test -RepositoryId 00000000-0000-0000-0000-000000000000

         It 'Should return stale branch' {
            Assert-VerifiableMock
         }

         It 'Should return 1 stale branch' {
            $staleBranches | Should -HaveCount 1
         }
      }

      Context 'Get-VSTeamStaleBranch by id throws' {
         Mock Invoke-RestMethod { throw [System.Net.WebException] "Test Exception." }

         It 'Should return a single repo by id' {
            { Get-VSTeamStaleBranch -ProjectName Test -RepositoryId 00000000-0000-0000-0000-000000000000 } | Should Throw
         }
      }
   }
}