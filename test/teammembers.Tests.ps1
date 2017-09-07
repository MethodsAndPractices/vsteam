Set-StrictMode -Version Latest

Get-Module team | Remove-Module -Force
Import-Module $PSScriptRoot\..\src\teammembers.psm1 -Force
Import-Module $PSScriptRoot\..\src\teams.psm1 -Force

InModuleScope teammembers {
   $env:TEAM_ACCT = 'https://test.visualstudio.com'

   Describe "TeamMembers" {
        . "$PSScriptRoot\mockProjectNameDynamicParam.ps1"
        
        Context 'Get-Teammember for specific project and team' {
            Mock Invoke-RestMethod { return @{value='teams'}}

            It 'Should return teammembers' {
                Get-Teammember -ProjectName TestProject -TeamId TestTeam
                # Make sure it was called with the correct URI
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
                    $Uri -eq 'https://test.visualstudio.com/_apis/projects/TestProject/teams/TestTeam/members?api-version=1.0'
                }
            }
        }

        Context 'Get-Teammember for specific project and team, with top' {
            Mock Invoke-RestMethod { return @{value='teams'}}

            It 'Should return teammembers' {
                Get-Teammember -ProjectName TestProject -TeamId TestTeam -Top 10
                # Make sure it was called with the correct URI
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
                    $Uri -eq 'https://test.visualstudio.com/_apis/projects/TestProject/teams/TestTeam/members?api-version=1.0&$top=10'
                }
            }            
        }

        Context 'Get-Teammember for specific project and team, with skip' {
            Mock Invoke-RestMethod { return @{value='teams'}}

            It 'Should return teammembers' {                
                Get-Teammember -ProjectName TestProject -TeamId TestTeam -Skip 5
                # Make sure it was called with the correct URI
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
                    $Uri -eq 'https://test.visualstudio.com/_apis/projects/TestProject/teams/TestTeam/members?api-version=1.0&$skip=5'
                }
            }
        }

        Context 'Get-Teammember for specific project and team, with top and skip' {
            Mock Invoke-RestMethod { return @{value='teams'}}

            It 'Should return teammembers' {                
                Get-Teammember -ProjectName TestProject -TeamId TestTeam -Top 10 -Skip 5
                # Make sure it was called with the correct URI
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
                    $Uri -eq 'https://test.visualstudio.com/_apis/projects/TestProject/teams/TestTeam/members?api-version=1.0&$top=10&$skip=5'
                }
            }            
        }

        Context 'Get-Teammember for specific team, fed through pipeline' {
            Mock Get-Team { return New-Object -TypeName PSObject -Prop @{projectname="TestProject"; name="TestTeam"} }
            Mock Invoke-RestMethod { return @{value='teammembers'}}

            It 'Should return teammembers' {
                Get-Team -ProjectName TestProject -TeamId "TestTeam" | Get-TeamMember

                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
                    $Uri -eq 'https://test.visualstudio.com/_apis/projects/TestProject/teams/TestTeam/members?api-version=1.0'                    
                }
            }
        }
    }

}