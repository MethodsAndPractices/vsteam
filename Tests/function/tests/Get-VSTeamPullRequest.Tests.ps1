Set-StrictMode -Version Latest

Describe 'VSTeamPullRequest' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      # You have to manually load the type file so the property reviewStatus
      # can be tested.
      Update-TypeData -AppendPath "$baseFolder/Source/types/vsteam_lib.PullRequest.ps1xml" -ErrorAction Ignore

      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Git' }

      $singleResult = Open-SampleFile 'Get-VSTeamPullRequest-Id_17.json'
   }

   Context 'Get-VSTeamPullRequest' {
      BeforeAll {
         Mock Invoke-RestMethod { Open-SampleFile 'Get-VSTeamPullRequest.json' }
         Mock Invoke-RestMethod {
            $result = $singleResult
            $result.reviewers[0].vote = 10
            $result.reviewers[1].vote = 10
            $result.reviewers[2].vote = -10
            $result.reviewers[3].vote = 0
            return $result
         } -ParameterFilter {
            $Uri -like "*101*"
         }

         Mock Invoke-RestMethod {
            $result = $singleResult
            $result.reviewers[0].vote = 10
            $result.reviewers[1].vote = 10
            $result.reviewers[2].vote = 10
            $result.reviewers[3].vote = 10
            return $result
         } -ParameterFilter {
            $Uri -like "*110*"
         }

         Mock Invoke-RestMethod {
            $result = $singleResult
            $result.reviewers[0].vote = 10
            $result.reviewers[1].vote = 10
            $result.reviewers[2].vote = -10
            $result.reviewers[3].vote = 10
            return $result
         } -ParameterFilter {
            $Uri -like "*100*"
         }
      }

      It 'with no parameters' {
         $Global:PSDefaultParameterValues.Remove("*-vsteam*:projectName")
         Get-VSTeamPullRequest

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/_apis/git/pullRequests?api-version=$(_getApiVersion Git)"
         }
      }

      It 'with default project name' {
         $Global:PSDefaultParameterValues["*-vsteam*:projectName"] = 'testproject'
         Get-VSTeamPullRequest -ProjectName testproject

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/testproject/_apis/git/pullRequests?api-version=$(_getApiVersion Git)"
         }
      }

      It 'By ProjectName' {
         $Global:PSDefaultParameterValues.Remove("*-vsteam*:projectName")
         Get-VSTeamPullRequest -ProjectName testproject

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/testproject/_apis/git/pullRequests?api-version=$(_getApiVersion Git)"
         }
      }

      It 'By ID' {
         Get-VSTeamPullRequest -Id 101

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/_apis/git/pullRequests/101?api-version=$(_getApiVersion Git)"
         }
      }

      It 'with All' {
         Get-VSTeamPullRequest -ProjectName Test -All

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -like "*api-version=$(_getApiVersion Git)*" -and
            $Uri -like "*Test/_apis/git*" -and
            $Uri -like "*status=all*"
         }
      }

      It 'with Status abandoned' {
         Get-VSTeamPullRequest -ProjectName Test -Status abandoned

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -like "*api-version=$(_getApiVersion Git)*" -and
            $Uri -like "*Test/_apis/git*" -and
            $Uri -like "*status=abandoned*"
         }
      }

      It 'with source branch' {
         Get-VSTeamPullRequest -ProjectName Test -SourceBranchRef "refs/heads/mybranch"

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -like "*api-version=$(_getApiVersion Git)*" -and
            $Uri -like "*Test/_apis/git*" -and
            $Uri -like "*searchCriteria.sourceRefName=refs/heads/mybranch*"
         }
      }

      It 'with target branch' {
         Get-VSTeamPullRequest -ProjectName Test -TargetBranchRef "refs/heads/mybranch"

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -like "*api-version=$(_getApiVersion Git)*" -and
            $Uri -like "*Test/_apis/git*" -and
            $Uri -like "*searchCriteria.targetRefName=refs/heads/mybranch*"
         }
      }

      It 'with repository id' {
         Get-VSTeamPullRequest -ProjectName Test -RepositoryId "93BBA613-2729-4158-9217-751E952AB4AF"

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -like "*api-version=$(_getApiVersion Git)*" -and
            $Uri -like "*Test/_apis/git*" -and
            $Uri -like "*repositories/93BBA613-2729-4158-9217-751E952AB4AF*"
         }
      }

      It 'with source repository id' {
         Get-VSTeamPullRequest -ProjectName Test -SourceRepositoryId "93BBA613-2729-4158-9217-751E952AB4AF"

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -like "*api-version=$(_getApiVersion Git)*" -and
            $Uri -like "*Test/_apis/git*" -and
            $Uri -like "*searchCriteria.sourceRepositoryId=93BBA613-2729-4158-9217-751E952AB4AF*"
         }
      }

      It 'with top and skip' {
         Get-VSTeamPullRequest -ProjectName Test -SourceRepositoryId "93BBA613-2729-4158-9217-751E952AB4AF" -Top 100 -Skip 200

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -like "*api-version=$(_getApiVersion Git)*" -and
            $Uri -like "*Test/_apis/git*" -and
            $Uri -like "*searchCriteria.sourceRepositoryId=93BBA613-2729-4158-9217-751E952AB4AF*" -and
            $Uri -like "*`$top=100*" -and
            $Uri -like "*`$skip=200*"
         }
      }

      It 'with source branch in wrong format throws' {
         { Get-VSTeamPullRequest -ProjectName Test -SourceBranchRef "garbage" } | Should -Throw
      }

      It 'with target branch in wrong format throws' {
         { Get-VSTeamPullRequest -ProjectName Test -TargetBranchRef "garbage" } | Should -Throw
      }

      It 'No Votes should be Pending Status' {
         $pr = Get-VSTeamPullRequest -Id 101

         $pr.reviewStatus | Should -Be "Pending"
      }

      It 'Postivite Votes should be Approved Status' {
         $pr = Get-VSTeamPullRequest -Id 110

         $pr.reviewStatus | Should -Be "Approved"
      }

      It 'Negative Votes should be Rejected Status' {
         $pr = Get-VSTeamPullRequest -Id 100

         $pr.reviewStatus | Should -Be "Rejected"
      }

      It 'with RepositoryId and IncludeCommits' {
         Get-VSTeamPullRequest -Id 101 -RepositoryId "93BBA613-2729-4158-9217-751E952AB4AF" -IncludeCommits

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -like "*test/_apis/git/repositories*" -and
            $Uri -like "*includeCommits=True" -and
            $Uri -like "*api-version=$(_getApiVersion Git)*" -and
            $Uri -like "*pullRequests/101*"
         }
      }
   }
}
