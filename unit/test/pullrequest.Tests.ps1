Set-StrictMode -Version Latest

InModuleScope pullrequest {

    Describe 'Pull Requests' {
        . "$PSScriptRoot\mocks\mockProjectNameDynamicParamNoPSet.ps1"

        [VSTeamVersions]::Account = 'https://dev.azure.com/brianschmitt'

        $singleResult = @{
            pullRequestId  = 1
            repositoryName = "test"
            reviewStatus   = "Approved"
            createdByUser  = "Test"
            creationDate   = "12/31/2018 23:59:59"
            title          = "test"
            description    = "Test"
            sourceRefname  = "refs/heads/test/testpr"
            mergeStatus    = "succeeded"
            reviewedByUser = ""
            status         = "active"
            url            = "https://dev.azure.com/test/_apis/git/pullRequests/1"
            artifactId     = ""
        }

        $collection = @{
            value = @($singleResult)
        }

        Context 'Show-VSTeamPullRequest by Id' {
            Mock Show-Browser

            it 'should show pull request' {
                Show-VSTeamPullRequest -Id 1
    
                Assert-MockCalled Show-Browser
            }
        }

        Context 'Show-VSTeamPullRequest with invalid ID' {
            it 'should show pull request' {
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
        }
    }
}