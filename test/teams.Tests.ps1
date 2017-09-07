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

        Context 'Add-Team with team name only' {
            Mock Invoke-RestMethod { return @{value='teams'}}

            It 'Should create a team' {
                Add-Team -ProjectName Test -TeamName "TestTeam"

                $expectedBody = '{ "name": "TestTeam", "description": "" }'

                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
                    $Uri -eq 'https://test.visualstudio.com/_apis/projects/Test/teams?api-version=1.0' -and
                    $Method -eq "Post" -and
                    $Body -eq $expectedBody
                }
            }
        }

        Context 'Add-Team with team name and description' {
            Mock Invoke-RestMethod { return @{value='teams'}}
            
            It 'Should create a team' {
                Add-Team -ProjectName Test -TeamName "TestTeam" -Description "Test Description"

                $expectedBody = '{ "name": "TestTeam", "description": "Test Description" }'

                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
                    $Uri -eq 'https://test.visualstudio.com/_apis/projects/Test/teams?api-version=1.0' -and
                    $Method -eq "Post" -and
                    $Body -eq $expectedBody
                }
            }
        }

        Context 'Update-Team with new team name' {
            Mock Invoke-RestMethod { return @{value='teams'}}
            
            It 'Should update the team' {
                Update-Team -ProjectName Test -TeamToUpdate "OldTeamName" -NewTeamName "NewTeamName"

                $expectedBody = '{ "name": "NewTeamName" }'

                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
                    $Uri -eq 'https://test.visualstudio.com/_apis/projects/Test/teams/OldTeamName?api-version=1.0' -and
                    $Method -eq "Patch" -and
                    $Body -eq $expectedBody
                }
            }
        }

        Context 'Update-Team with new description' {
            Mock Invoke-RestMethod { return @{value='teams'}}
            
            It 'Should update the team' {
                Update-Team -ProjectName Test -TeamToUpdate "OldTeamName" -Description "New Description"

                $expectedBody = '{"description": "New Description" }'

                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
                    $Uri -eq 'https://test.visualstudio.com/_apis/projects/Test/teams/OldTeamName?api-version=1.0' -and
                    $Method -eq "Patch" -and
                    $Body -eq $expectedBody
                }
            }
        }

        Context 'Update-Team with new team name and description' {
            Mock Invoke-RestMethod { return @{value='teams'}}
            
            It 'Should update the team' {
                Update-Team -ProjectName Test -TeamToUpdate "OldTeamName" -NewTeamName "NewTeamName" -Description "New Description"

                $expectedBody = '{ "name": "NewTeamName", "description": "New Description" }'

                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
                    $Uri -eq 'https://test.visualstudio.com/_apis/projects/Test/teams/OldTeamName?api-version=1.0' -and
                    $Method -eq "Patch" -and
                    $Body -eq $expectedBody
                }
            }
        }

        Context 'Update-Team, fed through pipeline' {
            Mock Get-Team { return New-Object -TypeName PSObject -Prop @{projectname="TestProject"; name="OldTeamName"} }
            Mock Invoke-RestMethod { return @{value='teams'}}

            It 'Should update the team' {
                Get-Team -ProjectName TestProject -TeamId "OldTeamName" | Update-Team -NewTeamName "NewTeamName" -Description "New Description"

                $expectedBody = '{ "name": "NewTeamName", "description": "New Description" }'

                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
                    $Uri -eq 'https://test.visualstudio.com/_apis/projects/TestProject/teams/OldTeamName?api-version=1.0' -and
                    $Method -eq "Patch" -and
                    $Body -eq $expectedBody
                }
            }
        }

        Context 'Remove-Team' {
            Mock Invoke-RestMethod { return @{value='teams'}}
            
            It 'Should remove the team' {
                Remove-Team -ProjectName Test -TeamId "TestTeam" -Force

                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
                    $Uri -eq 'https://test.visualstudio.com/_apis/projects/Test/teams/TestTeam?api-version=1.0' -and
                    $Method -eq "Delete"
                }
            }
        }

        Context 'Remove-Team, fed through pipeline' {
            Mock Get-Team { return New-Object -TypeName PSObject -Prop @{projectname="TestProject"; name="TestTeam"} }
            Mock Invoke-RestMethod { return @{value='teams'}}

            It 'Should remove the team' {
                Get-Team -ProjectName TestProject -TeamId "TestTeam" | Remove-Team -Force

                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
                    $Uri -eq 'https://test.visualstudio.com/_apis/projects/TestProject/teams/TestTeam?api-version=1.0' -and
                    $Method -eq "Delete"
                }
            }
        }
    }

}