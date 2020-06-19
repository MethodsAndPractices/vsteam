Set-StrictMode -Version Latest

Describe "VSTeamGitCommit" {
   BeforeAll {
      Import-Module SHiPS

      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

      . "$PSScriptRoot/../../Source/Classes/VSTeamLeaf.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamGitUserDate.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamGitCommitRef.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProjectCache.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectCompleter.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectValidateAttribute.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"

      ## Arrange
      # Make sure the project name is valid. By returning an empty array
      # all project names are valid. Otherwise, you name you pass for the
      # project in your commands must appear in the list.
      Mock _getProjects { return @() }

      $results = Get-Content "$PSScriptRoot\sampleFiles\gitCommitResults.json" -Raw | ConvertFrom-Json

      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Git' }
   }

   Context 'Get-VSTeamGitCommit' {
      BeforeAll {
         Mock Invoke-RestMethod { return $results }
      }

      It 'should return all commits for the repo' {
         Get-VSTeamGitCommit -ProjectName Test -RepositoryId 06E176BE-D3D2-41C2-AB34-5F4D79AEC86B
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -like "*repositories/06E176BE-D3D2-41C2-AB34-5F4D79AEC86B/commits*"
         }
      }

      It 'with many Parameters should return all commits for the repo' {
         Get-VSTeamGitCommit -ProjectName Test -RepositoryId '06E176BE-D3D2-41C2-AB34-5F4D79AEC86B' `
            -FromDate '2020-01-01' -ToDate '2020-03-01' `
            -ItemVersionVersionType 'commit' -ItemVersionVersion 'abcdef1234567890abcdef1234567890' -ItemVersionVersionOptions 'previousChange' `
            -CompareVersionVersionType 'commit' -CompareVersionVersion 'abcdef1234567890abcdef1234567890' -CompareVersionVersionOptions 'previousChange' `
            -FromCommitId 'abcdef' -ToCommitId 'fedcba' `
            -Author "Test" `
            -Top 100 -Skip 50 `
            -User "Test"

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

      It 'with ItemPath parameters should return all commits for the repo' {
         Get-VSTeamGitCommit -ProjectName Test -RepositoryId '06E176BE-D3D2-41C2-AB34-5F4D79AEC86B' `
            -ItemPath 'test' `
            -ExcludeDeletes `
            -HistoryMode 'fullHistory' `
            -Top 100 -Skip 50 `
            -User "Test"

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