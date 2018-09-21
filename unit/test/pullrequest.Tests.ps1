Set-StrictMode -Version Latest

InModuleScope workitems {
    [VSTeamVersions]::Account = 'https://dev.azure.com/test'

    Describe 'pullrequests' {
        # Mock the call to Get-PullRequest by the dynamic parameter for ProjectName
        Mock Invoke-RestMethod { return @() } -ParameterFilter {
            $Uri -like "*pullrequests*" 
        }
   
        . "$PSScriptRoot\mocks\mockProjectNameDynamicParamNoPSet.ps1"

        $obj = @{
            id  = 47
            rev = 1
            url = "https://dev.azure.com/test/_apis/git/pullRequests/47"
        }

        $collection = @{
            count = 1
            value = @($obj)
        }

        Context 'Show-VSTeamPullRequest' {
            Mock Show-Browser { }

            it 'should return url for mine' {
                Show-VSTeamPullRequest -Id 15

                Assert-MockCalled Show-Browser -Exactly -Scope It -Times 1 -ParameterFilter { $url -eq 'https://dev.azure.com/test/project/_git/repo/pullrequest/15' }
            }
        }

        Context 'Get-VSTeamPullRequest' {       

            It 'Without Default Project should get pull requests' {
                Mock Invoke-RestMethod {
                    # If this test fails uncomment the line below to see how the mock was called.
                    # Write-Host $args
               
                    return $collection
                }

                $Global:PSDefaultParameterValues.Remove("*:projectName")
                Get-VSTeamPullRequest -ProjectName test -Id 47

                # With PowerShell core the order of the query string is not the 
                # same from run to run!  So instead of testing the entire string
                # matches I have to search for the portions I expect but can't
                # assume the order. 
                # The general string should look like this:
                # https://dev.azure.com/test/test/_apis/git/pullRequests/47?api-version=4.0
                Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
                    $Uri -like "*https://dev.azure.com/test/test/_apis/git/pullRequests/*" -and
                    $Uri -like "*api-version=$([VSTeamVersions]::Core)*" -and
                    $Uri -like "*47*"
                }
            }

            It 'With Default Project should get pull request' {
                Mock Invoke-RestMethod {
                    # If this test fails uncomment the line below to see how the mock was called.
                    # Write-Host $args
                    return $obj
                }

                $Global:PSDefaultParameterValues["*:projectName"] = 'test'
                Get-VSTeamWorkItem -ProjectName test -Id 47

                Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
                    $Uri -eq "https://dev.azure.com/test/test/_apis/git/pullRequests/47?api-version=$([VSTeamVersions]::Core)"
                }
            }
        }
    }
}