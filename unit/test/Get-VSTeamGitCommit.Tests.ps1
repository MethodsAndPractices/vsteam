Set-StrictMode -Version Latest

InModuleScope VSTeam {

   # Set the account to use for testing. A normal user would do this
   # using the Set-VSTeamAccount function.
   [VSTeamVersions]::Account = 'https://dev.azure.com/test'

   $results = [PSCustomObject]@{
      count = 2
      value = @(
         [PSCustomObject]@{
            author = [PSCustomObject]@{
               date = '2020-02-19T15:12:01Z'
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
               date = '2020-02-19T15:12:01Z'
               email = 'test@test.com'
               name = 'Test User'
            }
            remoteUrl = 'https://dev.azure.com/test/test/_git/test/commit/1234567890abcdef1234567890abcdef'
            url = 'https://dev.azure.com/test/21AF684D-AFFB-4F9A-9D49-866EF24D6A4A/_apid/git/repositories/06E176BE-D3D2-41C2-AB34-5F4D79AEC86B/commits/1234567890abcdef1234567890abcdef'
         },
         [PSCustomObject]@{
            author = [PSCustomObject]@{
               date = '2020-02-20T01:00:01Z'
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
               date = '2020-02-20T01:00:01Z'
               email = 'eample@example.com'
               name = 'Example User'
            }
            remoteUrl = 'https://dev.azure.com/test/test/_git/test/commit/abcdef1234567890abcdef1234567890'
            url = 'https://dev.azure.com/test/21AF684D-AFFB-4F9A-9D49-866EF24D6A4A/_apid/git/repositories/06E176BE-D3D2-41C2-AB34-5F4D79AEC86B/commits/abcdef1234567890abcdef1234567890'
         }
      )
   }

   Describe "Git VSTS" {
      # Mock the call to Get-Projects by the dynamic parameter for ProjectName
      Mock Invoke-RestMethod { return @() } -ParameterFilter {
         $Uri -like "*_apis/projects*"
      }

      . "$PSScriptRoot\mocks\mockProjectNameDynamicParam.ps1"

      Context 'Get-VSTeamGitCommit' {
         Mock Invoke-RestMethod { return $results } -Verifiable -ParameterFilter {
            $Uri -like "*repositories/06E176BE-D3D2-41C2-AB34-5F4D79AEC86B/commits*"
         }

         Get-VSTeamGitCommit -ProjectName Test -RepositoryId 06E176BE-D3D2-41C2-AB34-5F4D79AEC86B

         It 'Should return all commits for the repo' {
            Assert-VerifiableMock
         }
      }

      Context 'Get-VSTeamGitCommit with many Parameters' {
         Mock Invoke-RestMethod { return $results } -Verifiable -ParameterFilter {
            $Uri -like "*repositories/06E176BE-D3D2-41C2-AB34-5F4D79AEC86B/commits*" -and
            $Uri -like "*searchCriteria.fromDate=2020-01-01T00:00:00Z*" -and
            $Uri -like "*searchCriteria.toDate=2020-03-01T00:00:00Z*" -and
            $Uri -like "*searchCriteria.itemVersion.versionType=commit*" -and
            $Uri -like "*searchCriteria.itemVersion.version=abcdef1234567890abcdef1234567890*" -and
            $Uri -like "*searchCriteria.itemVersion.versionOptions=previousChange*" -and
            $Uri -like "*searchCriteria.compareVersion.versionType=commit*" -and
            $Uri -like "*searchCriteria.compareVersion.version=abcdef1234567890abcdef1234567890*" -and
            $Uri -like "*searchCriteria.compareVersion.versionOptions=previousChange*" -and
            $Uri -like "*searchCriteria.fromCommitId=abcdef*" -and
            $Uri -like "*searchCriteria.toCommitId=fedcba*" -and
            $Uri -like "*searchCriteria.author=Test*" -and
            $Uri -like "*searchCriteria.user=Test*" -and
            $Uri -like "*searchCriteria.`$top=100*" -and
            $Uri -like "*searchCriteria.`$skip=50*"
         }

         Get-VSTeamGitCommit -ProjectName Test -RepositoryId '06E176BE-D3D2-41C2-AB34-5F4D79AEC86B' `
            -FromDate '2020-01-01' -ToDate '2020-03-01' `
            -ItemVersionVersionType 'commit' -ItemVersionVersion 'abcdef1234567890abcdef1234567890' -ItemVersionVersionOptions 'previousChange' `
            -CompareVersionVersionType 'commit' -CompareVersionVersion 'abcdef1234567890abcdef1234567890' -CompareVersionVersionOptions 'previousChange' `
            -FromCommitId 'abcdef' -ToCommitId 'fedcba' `
            -Author "Test" `
            -Top 100 -Skip 50 `
            -User "Test"

         It 'Should return all commits for the repo' {
            Assert-VerifiableMock
         }
      }

      Context 'Get-VSTeamGitCommit with ItemPath parameters' {
         Mock Invoke-RestMethod { return $results } -Verifiable -ParameterFilter {
            $Uri -like "*repositories/06E176BE-D3D2-41C2-AB34-5F4D79AEC86B/commits*" -and
            $Uri -like "*searchCriteria.itemPath=test*" -and
            $Uri -like "*searchCriteria.excludeDeletes=true*" -and
            $Uri -like "*searchCriteria.historyMode=fullHistory*" -and
            $Uri -like "*searchCriteria.`$top=100*" -and
            $Uri -like "*searchCriteria.`$skip=50*"
         }

         Get-VSTeamGitCommit -ProjectName Test -RepositoryId '06E176BE-D3D2-41C2-AB34-5F4D79AEC86B' `
            -ItemPath 'test' `
            -ExcludeDeletes `
            -HistoryMode 'fullHistory' `
            -Top 100 -Skip 50 `
            -User "Test"

         It 'Should return all commits for the repo' {
            Assert-VerifiableMock
         }
      }

      Context 'Get-VSTeamGitCommit by id throws' {
         Mock Invoke-RestMethod { throw [System.Net.WebException] "Test Exception." }

         It 'Should throw' {
            { Get-VSTeamGitCommit -ProjectName Test -RepositoryId  06E176BE-D3D2-41C2-AB34-5F4D79AEC86B } | Should Throw
         }
      }
   }
}