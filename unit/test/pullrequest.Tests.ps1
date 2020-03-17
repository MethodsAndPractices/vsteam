Set-StrictMode -Version Latest

$env:Testing=$true
InModuleScope VSTeam {

    Describe 'Pull Requests' {
        . "$PSScriptRoot\mocks\mockProjectNameDynamicParamNoPSet.ps1"

        Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable

        # You have to set the version or the api-version will not be added when
        # [VSTeamVersions]::Core = ''
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

        Context 'Show-VSTeamPullRequest' {
            It 'Show-VSTeamPullRequest by Id' {
                Mock Invoke-RestMethod { return $singleResult }
                Mock Show-Browser

                Show-VSTeamPullRequest -Id 1

                Assert-MockCalled Show-Browser -Exactly -Scope It -Times 1 -ParameterFilter {
                    $url -eq "https://dev.azure.com/test/testproject/_git/testreponame/pullrequest/1"
                }
            }

            It 'Show-VSTeamPullRequest with invalid ID' {
                Mock Invoke-RestMethod { return $singleResult }
                Mock Show-Browser { throw }

                { Show-VSTeamPullRequest -Id 999999 } | Should throw
            }
        }

        Context 'Get-VSTeamPullRequest' {

            It 'Get-VSTeamPullRequest with no parameters' {
                Mock Invoke-RestMethod { return $collection }

                $Global:PSDefaultParameterValues.Remove("*:ProjectName")
                Get-VSTeamPullRequest

                Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
                    $Uri -eq "https://dev.azure.com/test/_apis/git/pullRequests?api-version=$([VSTeamVersions]::Git)"
                }
            }

            It 'Get-VSTeamPullRequest with default project name' {
                Mock Invoke-RestMethod { return $collection }

                $Global:PSDefaultParameterValues["*:ProjectName"] = 'testproject'
                Get-VSTeamPullRequest -ProjectName testproject

                Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
                    $Uri -eq "https://dev.azure.com/test/testproject/_apis/git/pullRequests?api-version=$([VSTeamVersions]::Git)"
                }
            }

            It 'Get-VSTeamPullRequest By ProjectName' {
                Mock Invoke-RestMethod { return $collection }

                $Global:PSDefaultParameterValues.Remove("*:ProjectName")
                Get-VSTeamPullRequest -ProjectName testproject

                Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
                    $Uri -eq "https://dev.azure.com/test/testproject/_apis/git/pullRequests?api-version=$([VSTeamVersions]::Git)"
                }
            }

            It 'Get-VSTeamPullRequest By ID' {
                Mock Invoke-RestMethod { return $singleResult }

                Get-VSTeamPullRequest -Id 1

                Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
                    $Uri -eq "https://dev.azure.com/test/_apis/git/pullRequests/1?api-version=$([VSTeamVersions]::Git)"
                }
            }

            It 'Get-VSTeamPullRequest with All' {
               Mock Invoke-RestMethod { return $singleResult }

               Get-VSTeamPullRequest -ProjectName Test -All

               Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
                  $Uri -like "*api-version=$([VSTeamVersions]::Git)*" -and
                  $Uri -like "*Test/_apis/git*" -and
                  $Uri -like "*status=all*"
               }
            }

            It 'Get-VSTeamPullRequest with Status abandoned' {
               Mock Invoke-RestMethod { return $singleResult }

               Get-VSTeamPullRequest -ProjectName Test -Status abandoned

               Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
                  $Uri -like "*api-version=$([VSTeamVersions]::Git)*" -and
                  $Uri -like "*Test/_apis/git*" -and
                  $Uri -like "*status=abandoned*"
               }
            }

            It 'Get-VSTeamPullRequest with source branch' {
               Mock Invoke-RestMethod { return $singleResult }

               Get-VSTeamPullRequest -ProjectName Test -SourceBranchRef "refs/heads/mybranch"

               Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
                  $Uri -like "*api-version=$([VSTeamVersions]::Git)*" -and
                  $Uri -like "*Test/_apis/git*" -and
                  $Uri -like "*searchCriteria.sourceRefName=refs/heads/mybranch*"
               }
            }

            It 'Get-VSTeamPullRequest with target branch' {
               Mock Invoke-RestMethod { return $singleResult }

               Get-VSTeamPullRequest -ProjectName Test -TargetBranchRef "refs/heads/mybranch"

               Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
                  $Uri -like "*api-version=$([VSTeamVersions]::Git)*" -and
                  $Uri -like "*Test/_apis/git*" -and
                  $Uri -like "*searchCriteria.targetRefName=refs/heads/mybranch*"
               }
            }

            It 'Get-VSTeamPullRequest with repository id' {
               Mock Invoke-RestMethod { return $singleResult }

               Get-VSTeamPullRequest -ProjectName Test -RepositoryId "93BBA613-2729-4158-9217-751E952AB4AF"

               Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
                  $Uri -like "*api-version=$([VSTeamVersions]::Git)*" -and
                  $Uri -like "*Test/_apis/git*" -and
                  $Uri -like "*repositories/93BBA613-2729-4158-9217-751E952AB4AF*"
               }
            }

            It 'Get-VSTeamPullRequest with source repository id' {
               Mock Invoke-RestMethod { return $singleResult }

               Get-VSTeamPullRequest -ProjectName Test -SourceRepositoryId "93BBA613-2729-4158-9217-751E952AB4AF"

               Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
                  $Uri -like "*api-version=$([VSTeamVersions]::Git)*" -and
                  $Uri -like "*Test/_apis/git*" -and
                  $Uri -like "*searchCriteria.sourceRepositoryId=93BBA613-2729-4158-9217-751E952AB4AF*"
               }
            }

            It 'Get-VSTeamPullRequest with top and skip' {
               Mock Invoke-RestMethod { return $singleResult }

               Get-VSTeamPullRequest -ProjectName Test -SourceRepositoryId "93BBA613-2729-4158-9217-751E952AB4AF" -Top 100 -Skip 200

               Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
                  $Uri -like "*api-version=$([VSTeamVersions]::Git)*" -and
                  $Uri -like "*Test/_apis/git*" -and
                  $Uri -like "*searchCriteria.sourceRepositoryId=93BBA613-2729-4158-9217-751E952AB4AF*" -and
                  $Uri -like "*`$top=100*" -and
                  $Uri -like "*`$skip=200*"
               }
            }

            It 'Get-VSTeamPullRequest with source branch in wrong format throws' {
               Mock Invoke-RestMethod { return $singleResult }

               { Get-VSTeamPullRequest -ProjectName Test -SourceBranchRef "garbage" } | should throw
            }

            It 'Get-VSTeamPullRequest with target branch in wrong format throws' {
               Mock Invoke-RestMethod { return $singleResult }

               { Get-VSTeamPullRequest -ProjectName Test -TargetBranchRef "garbage" } | should throw
            }

            It 'Get-VSTeamPullRequest No Votes should be Pending Status' {
                Mock Invoke-RestMethod { return $singleResult }

                $pr = Get-VSTeamPullRequest -Id 1

                $pr.reviewStatus | Should be "Pending"
            }

            It 'Get-VSTeamPullRequest Postivite Votes should be Approved Status' {
                Mock Invoke-RestMethod {
                    $result = $singleResult
                    $result.reviewers.vote = 10
                    return $result
                }

                $pr = Get-VSTeamPullRequest -Id 1

                $pr.reviewStatus | Should be "Approved"
            }

            It 'Get-VSTeamPullRequest Negative Votes should be Rejected Status' {
                Mock Invoke-RestMethod {
                    $result = $singleResult
                    $result.reviewers.vote = -10
                    return $result
                }

                $pr = Get-VSTeamPullRequest -Id 1

                $pr.reviewStatus | Should be "Rejected"
            }
        }
    }
}