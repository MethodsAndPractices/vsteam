Set-StrictMode -Version Latest

#region include
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProcess.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Classes/VSTeamProcessCache.ps1"
. "$here/../../Source/Private/applyTypes.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/$sut"
#endregion

Describe 'VSTeamPullRequest' {
   # You have to manually load the type file so the property reviewStatus
   # can be tested.
   Update-TypeData -AppendPath "$here/../../Source/types/Team.PullRequest.ps1xml" -ErrorAction Ignore

   . "$PSScriptRoot\mocks\mockProjectNameDynamicParamNoPSet.ps1"

   Mock _getInstance { return 'https://dev.azure.com/test' }

   # You have to set the version or the api-version will not be added when versions = ''
   [VSTeamVersions]::Git = '5.1-preview'

   $singleResult = @{
      pullRequestId  = 1
      repositoryName = "testreponame"
      repository     = @{
         project = @{
            name = "testproject"
         }
      }
      reviewers      = @{
         vote = 0
      }
   }

   $collection = @{
      value = @($singleResult)
   }

   Context 'Get-VSTeamPullRequest' {
      Mock Invoke-RestMethod { return $collection }
      Mock Invoke-RestMethod {
         $result = $singleResult
         $result.reviewers.vote = 0
         return $result
      } -ParameterFilter { 
         $Uri -like "*101*"
      }

      Mock Invoke-RestMethod {
         $result = $singleResult
         $result.reviewers.vote = 10
         return $result
      } -ParameterFilter { 
         $Uri -like "*110*"
      }

      Mock Invoke-RestMethod {
         $result = $singleResult
         $result.reviewers.vote = -10
         return $result
      } -ParameterFilter { 
         $Uri -like "*100*"
      }

      It 'with no parameters' {
         $Global:PSDefaultParameterValues.Remove("*:ProjectName")
         Get-VSTeamPullRequest

         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/_apis/git/pullRequests?api-version=$([VSTeamVersions]::Git)"
         }
      }

      It 'with default project name' {
         $Global:PSDefaultParameterValues["*:ProjectName"] = 'testproject'
         Get-VSTeamPullRequest -ProjectName testproject

         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/testproject/_apis/git/pullRequests?api-version=$([VSTeamVersions]::Git)"
         }
      }

      It 'By ProjectName' {
         $Global:PSDefaultParameterValues.Remove("*:ProjectName")
         Get-VSTeamPullRequest -ProjectName testproject

         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/testproject/_apis/git/pullRequests?api-version=$([VSTeamVersions]::Git)"
         }
      }

      It 'By ID' {
         Get-VSTeamPullRequest -Id 101

         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/_apis/git/pullRequests/101?api-version=$([VSTeamVersions]::Git)"
         }
      }

      It 'with All' {
         Get-VSTeamPullRequest -ProjectName Test -All

         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -like "*api-version=$([VSTeamVersions]::Git)*" -and
            $Uri -like "*Test/_apis/git*" -and
            $Uri -like "*status=all*"
         }
      }

      It 'with Status abandoned' {
         Get-VSTeamPullRequest -ProjectName Test -Status abandoned

         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -like "*api-version=$([VSTeamVersions]::Git)*" -and
            $Uri -like "*Test/_apis/git*" -and
            $Uri -like "*status=abandoned*"
         }
      }

      It 'with source branch' {
         Get-VSTeamPullRequest -ProjectName Test -SourceBranchRef "refs/heads/mybranch"

         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -like "*api-version=$([VSTeamVersions]::Git)*" -and
            $Uri -like "*Test/_apis/git*" -and
            $Uri -like "*searchCriteria.sourceRefName=refs/heads/mybranch*"
         }
      }

      It 'with target branch' {
         Get-VSTeamPullRequest -ProjectName Test -TargetBranchRef "refs/heads/mybranch"

         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -like "*api-version=$([VSTeamVersions]::Git)*" -and
            $Uri -like "*Test/_apis/git*" -and
            $Uri -like "*searchCriteria.targetRefName=refs/heads/mybranch*"
         }
      }

      It 'with repository id' {
         Get-VSTeamPullRequest -ProjectName Test -RepositoryId "93BBA613-2729-4158-9217-751E952AB4AF"

         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -like "*api-version=$([VSTeamVersions]::Git)*" -and
            $Uri -like "*Test/_apis/git*" -and
            $Uri -like "*repositories/93BBA613-2729-4158-9217-751E952AB4AF*"
         }
      }

      It 'with source repository id' {
         Get-VSTeamPullRequest -ProjectName Test -SourceRepositoryId "93BBA613-2729-4158-9217-751E952AB4AF"

         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -like "*api-version=$([VSTeamVersions]::Git)*" -and
            $Uri -like "*Test/_apis/git*" -and
            $Uri -like "*searchCriteria.sourceRepositoryId=93BBA613-2729-4158-9217-751E952AB4AF*"
         }
      }

      It 'with top and skip' {
         Get-VSTeamPullRequest -ProjectName Test -SourceRepositoryId "93BBA613-2729-4158-9217-751E952AB4AF" -Top 100 -Skip 200

         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -like "*api-version=$([VSTeamVersions]::Git)*" -and
            $Uri -like "*Test/_apis/git*" -and
            $Uri -like "*searchCriteria.sourceRepositoryId=93BBA613-2729-4158-9217-751E952AB4AF*" -and
            $Uri -like "*`$top=100*" -and
            $Uri -like "*`$skip=200*"
         }
      }

      It 'with source branch in wrong format throws' {
         { Get-VSTeamPullRequest -ProjectName Test -SourceBranchRef "garbage" } | should throw
      }

      It 'with target branch in wrong format throws' {
         { Get-VSTeamPullRequest -ProjectName Test -TargetBranchRef "garbage" } | should throw
      }

      It 'No Votes should be Pending Status' {
         $pr = Get-VSTeamPullRequest -Id 101

         $pr.reviewStatus | Should be "Pending"
      }

      It 'Postivite Votes should be Approved Status' {
         $pr = Get-VSTeamPullRequest -Id 110

         $pr.reviewStatus | Should be "Approved"
      }

      It 'Negative Votes should be Rejected Status' {
         $pr = Get-VSTeamPullRequest -Id 100

         $pr.reviewStatus | Should be "Rejected"
      }
   }
}