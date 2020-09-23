Set-StrictMode -Version Latest

Describe "VSTeamGitCommit" {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      
      ## Arrange
      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Git' }
   }

   Context 'Get-VSTeamGitCommit' {
      BeforeAll {
         Mock Invoke-RestMethod { Open-SampleFile 'gitCommitResults.json' }
      }

      It 'should return all commits for the repo' {
         ## Act
         Get-VSTeamGitCommit -ProjectName Test -RepositoryId 06E176BE-D3D2-41C2-AB34-5F4D79AEC86B

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -like "*repositories/06E176BE-D3D2-41C2-AB34-5F4D79AEC86B/commits*"
         }
      }

      It 'should return all commits for the repo with many Parameters' {
         ## Act
         Get-VSTeamGitCommit -ProjectName Test `
            -RepositoryId '06E176BE-D3D2-41C2-AB34-5F4D79AEC86B' `
            -FromDate '2020-01-01' `
            -ToDate '2020-03-01' `
            -ItemVersionVersionType 'commit' `
            -ItemVersionVersion 'abcdef1234567890abcdef1234567890' `
            -ItemVersionVersionOptions 'previousChange' `
            -CompareVersionVersionType 'commit' `
            -CompareVersionVersion 'abcdef1234567890abcdef1234567890' `
            -CompareVersionVersionOptions 'previousChange' `
            -FromCommitId 'abcdef' `
            -ToCommitId 'fedcba' `
            -Author "Test" `
            -Top 100 `
            -Skip 50 `
            -User "Test"

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
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
      }

      It 'should return all commits for the repo with ItemPath parameters' {
         ## Act
         Get-VSTeamGitCommit -ProjectName Test `
            -RepositoryId '06E176BE-D3D2-41C2-AB34-5F4D79AEC86B' `
            -ItemPath 'test' `
            -ExcludeDeletes `
            -HistoryMode 'fullHistory' `
            -Top 100 -Skip 50 `
            -User "Test"

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -like "*repositories/06E176BE-D3D2-41C2-AB34-5F4D79AEC86B/commits*" -and
            $Uri -like "*searchCriteria.itemPath=test*" -and
            $Uri -like "*searchCriteria.excludeDeletes=true*" -and
            $Uri -like "*searchCriteria.historyMode=fullHistory*" -and
            $Uri -like "*searchCriteria.`$top=100*" -and
            $Uri -like "*searchCriteria.`$skip=50*"
         }
      }
   }
}