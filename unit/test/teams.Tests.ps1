Set-StrictMode -Version Latest

Get-Module team | Remove-Module -Force
Import-Module $PSScriptRoot\..\..\src\teams.psm1 -Force

InModuleScope teams {
   $env:TEAM_ACCT = 'https://test.visualstudio.com'

   Describe "Teams" {
        . "$PSScriptRoot\mockProjectNameDynamicParam.ps1"
        
        Context 'Get-VSTeam with project name' {  
            Mock Invoke-RestMethod { return @{value='teams'}}

            It 'Should return teams' {
                Get-VSTeam -ProjectName Test

                # Make sure it was called with the correct URI
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
                    $Uri -eq 'https://test.visualstudio.com/_apis/projects/Test/teams?api-version=1.0'
                }
            }
        }

        Context 'Get-VSTeam with project name, with top' {  
            Mock Invoke-RestMethod { return @{value='teams'}}

            It 'Should return teams' {
                Get-VSTeam -ProjectName Test -Top 10

                # Make sure it was called with the correct URI
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
                    $Uri -eq 'https://test.visualstudio.com/_apis/projects/Test/teams?api-version=1.0&$top=10'
                }
            }
        }

        Context 'Get-VSTeam with project name, with skip' {  
            Mock Invoke-RestMethod { return @{value='teams'}}

            It 'Should return teams' {
                Get-VSTeam -ProjectName Test -Skip 10

                # Make sure it was called with the correct URI
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
                    $Uri -eq 'https://test.visualstudio.com/_apis/projects/Test/teams?api-version=1.0&$skip=10'
                }
            }
        }

        Context 'Get-VSTeam with project name, with top and skip' {  
            Mock Invoke-RestMethod { return @{value='teams'}}

            It 'Should return teams' {
                Get-VSTeam -ProjectName Test -Top 10 -Skip 5

                # Make sure it was called with the correct URI
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
                    $Uri -eq 'https://test.visualstudio.com/_apis/projects/Test/teams?api-version=1.0&$top=10&$skip=5'
                }
            }
        }

        Context 'Get-VSTeam with specific project and specific team' {  
            Mock Invoke-RestMethod { return @{value='teams'}}

            It 'Should return teams' {
                Get-VSTeam -ProjectName Test -TeamId TestTeam

                # Make sure it was called with the correct URI
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
                    $Uri -eq 'https://test.visualstudio.com/_apis/projects/Test/teams/TestTeam?api-version=1.0'
                }
            }
        }

        Context 'Add-VSTeam with team name only' {
            Mock Invoke-RestMethod { return @{value='teams'}}

            It 'Should create a team' {
                Add-VSTeam -ProjectName Test -TeamName "TestTeam"

                $expectedBody = '{ "name": "TestTeam", "description": "" }'

                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
                    $Uri -eq 'https://test.visualstudio.com/_apis/projects/Test/teams?api-version=1.0' -and
                    $Method -eq "Post" -and
                    $Body -eq $expectedBody
                }
            }
        }

        Context 'Add-VSTeam with team name and description' {
            Mock Invoke-RestMethod { return @{value='teams'}}
            
            It 'Should create a team' {
                Add-VSTeam -ProjectName Test -TeamName "TestTeam" -Description "Test Description"

                $expectedBody = '{ "name": "TestTeam", "description": "Test Description" }'

                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
                    $Uri -eq 'https://test.visualstudio.com/_apis/projects/Test/teams?api-version=1.0' -and
                    $Method -eq "Post" -and
                    $Body -eq $expectedBody
                }
            }
        }

        Context 'Update-VSTeam with new team name' {
            Mock Invoke-RestMethod { return @{value='teams'}}
            
            It 'Should update the team' {
                Update-VSTeam -ProjectName Test -TeamToUpdate "OldTeamName" -NewTeamName "NewTeamName"

                $expectedBody = '{ "name": "NewTeamName" }'

                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
                    $Uri -eq 'https://test.visualstudio.com/_apis/projects/Test/teams/OldTeamName?api-version=1.0' -and
                    $Method -eq "Patch" -and
                    $Body -eq $expectedBody
                }
            }
        }

        Context 'Update-VSTeam with new description' {
            Mock Invoke-RestMethod { return @{value='teams'}}
            
            It 'Should update the team' {
                Update-VSTeam -ProjectName Test -TeamToUpdate "OldTeamName" -Description "New Description"

                $expectedBody = '{"description": "New Description" }'

                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
                    $Uri -eq 'https://test.visualstudio.com/_apis/projects/Test/teams/OldTeamName?api-version=1.0' -and
                    $Method -eq "Patch" -and
                    $Body -eq $expectedBody
                }
            }
        }

        Context 'Update-VSTeam with new team name and description' {
            Mock Invoke-RestMethod { return @{value='teams'}}
            
            It 'Should update the team' {
                Update-VSTeam -ProjectName Test -TeamToUpdate "OldTeamName" -NewTeamName "NewTeamName" -Description "New Description"

                $expectedBody = '{ "name": "NewTeamName", "description": "New Description" }'

                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
                    $Uri -eq 'https://test.visualstudio.com/_apis/projects/Test/teams/OldTeamName?api-version=1.0' -and
                    $Method -eq "Patch" -and
                    $Body -eq $expectedBody
                }
            }
        }

        Context 'Update-VSTeam, fed through pipeline' {
            Mock Get-VSTeam { return New-Object -TypeName PSObject -Prop @{projectname="TestProject"; name="OldTeamName"} }
            Mock Invoke-RestMethod { return @{value='teams'}}

            It 'Should update the team' {
                Get-VSTeam -ProjectName TestProject -TeamId "OldTeamName" | Update-VSTeam -NewTeamName "NewTeamName" -Description "New Description"

                $expectedBody = '{ "name": "NewTeamName", "description": "New Description" }'

                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
                    $Uri -eq 'https://test.visualstudio.com/_apis/projects/TestProject/teams/OldTeamName?api-version=1.0' -and
                    $Method -eq "Patch" -and
                    $Body -eq $expectedBody
                }
            }
        }

        Context 'Remove-VSTeam' {
            Mock Invoke-RestMethod { return @{value='teams'}}
            
            It 'Should remove the team' {
                Remove-VSTeam -ProjectName Test -TeamId "TestTeam" -Force

                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
                    $Uri -eq 'https://test.visualstudio.com/_apis/projects/Test/teams/TestTeam?api-version=1.0' -and
                    $Method -eq "Delete"
                }
            }
        }

        Context 'Remove-VSTeam, fed through pipeline' {
            Mock Get-VSTeam { return New-Object -TypeName PSObject -Prop @{projectname="TestProject"; name="TestTeam"} }
            Mock Invoke-RestMethod { return @{value='teams'}}

            It 'Should remove the team' {
                Get-VSTeam -ProjectName TestProject -TeamId "TestTeam" | Remove-VSTeam -Force

                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
                    $Uri -eq 'https://test.visualstudio.com/_apis/projects/TestProject/teams/TestTeam?api-version=1.0' -and
                    $Method -eq "Delete"
                }
            }
        }
    }

}