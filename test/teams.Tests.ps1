Set-StrictMode -Version Latest

Get-Module team | Remove-Module -Force
Import-Module $PSScriptRoot\..\src\teams.psm1 -Force

InModuleScope teams {
   $env:TEAM_ACCT = 'https://test.visualstudio.com'

   Describe "Teams" {
        . "$PSScriptRoot\mockProjectNameDynamicParam.ps1"
        
        Context 'Get-Team with project name' {  
            Mock Invoke-RestMethod { return @{value='teams'}}

            It 'Should return teams' {
                Get-Team -ProjectName Test

                # Make sure it was called with the correct URI
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
                    $Uri -eq 'https://test.visualstudio.com/_apis/projects/Test/teams?api-version=1.0'
                }
            }
        }

        Context 'Get-Team with project name, with top' {  
            Mock Invoke-RestMethod { return @{value='teams'}}

            It 'Should return teams' {
                Get-Team -ProjectName Test -Top 10

                # Make sure it was called with the correct URI
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
                    $Uri -eq 'https://test.visualstudio.com/_apis/projects/Test/teams?api-version=1.0&$top=10'
                }
            }
        }

        Context 'Get-Team with project name, with skip' {  
            Mock Invoke-RestMethod { return @{value='teams'}}

            It 'Should return teams' {
                Get-Team -ProjectName Test -Skip 10

                # Make sure it was called with the correct URI
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
                    $Uri -eq 'https://test.visualstudio.com/_apis/projects/Test/teams?api-version=1.0&$skip=10'
                }
            }
        }

        Context 'Get-Team with project name, with top and skip' {  
            Mock Invoke-RestMethod { return @{value='teams'}}

            It 'Should return teams' {
                Get-Team -ProjectName Test -Top 10 -Skip 5

                # Make sure it was called with the correct URI
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
                    $Uri -eq 'https://test.visualstudio.com/_apis/projects/Test/teams?api-version=1.0&$top=10&$skip=5'
                }
            }
        }

        Context 'Get-Team with specific project and specific team' {  
            Mock Invoke-RestMethod { return @{value='teams'}}

            It 'Should return teams' {
                Get-Team -ProjectName Test -TeamId TestTeam

                # Make sure it was called with the correct URI
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
                    $Uri -eq 'https://test.visualstudio.com/_apis/projects/Test/teams/TestTeam?api-version=1.0'
                }
            }
        }
    }

}