Set-StrictMode -Version Latest

InModuleScope pullrequest {

    Describe 'Pull Requests' {
        . "$PSScriptRoot\mocks\mockProjectNameDynamicParamNoPSet.ps1"

        [VSTeamVersions]::Account = 'https://dev.azure.com/test'

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
                    $url -eq "$([VSTeamVersions]::Account)/testproject/_git/testreponame/pullrequest/1"
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
                    $Uri -eq "$([VSTeamVersions]::Account)/_apis/git/pullRequests/?api-version=$([VSTeamVersions]::Core)"
                }
            }

            It 'Get-VSTeamPullRequest with default project name' {
                Mock Invoke-RestMethod { return $collection }

                $Global:PSDefaultParameterValues["*:ProjectName"] = 'testproject'
                Get-VSTeamPullRequest -ProjectName testproject

                Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
                    $Uri -eq "$([VSTeamVersions]::Account)/testproject/_apis/git/pullRequests/?api-version=$([VSTeamVersions]::Core)"
                }
            }

            It 'Get-VSTeamPullRequest By ProjectName' {
                Mock Invoke-RestMethod { return $collection }

                $Global:PSDefaultParameterValues.Remove("*:ProjectName")
                Get-VSTeamPullRequest -ProjectName testproject

                Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
                    $Uri -eq "$([VSTeamVersions]::Account)/testproject/_apis/git/pullRequests/?api-version=$([VSTeamVersions]::Core)"
                }
            }

            It 'Get-VSTeamPullRequest By ID' {
                Mock Invoke-RestMethod { return $singleResult }

                Get-VSTeamPullRequest -Id 1

                Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
                    $Uri -eq "$([VSTeamVersions]::Account)/_apis/git/pullRequests/1?api-version=$([VSTeamVersions]::Core)"
                }
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