Set-StrictMode -Version Latest

Get-Module team | Remove-Module -Force
Import-Module $PSScriptRoot\..\..\src\usermanagement.psm1 -Force
Import-Module $PSScriptRoot\..\..\src\teams.psm1 -Force

InModuleScope usermanagement {
   $env:TEAM_ACCT = 'https://test.visualstudio.com'

   Describe "UserManagement" {
        . "$PSScriptRoot\mockProjectNameDynamicParam.ps1"
        
        Context 'Get-VSTeamAccountUser for specific user' {
            Mock Invoke-RestMethod { 
                return @{
                    users = @(
                        @{
                            name = 'Test User'
                            SignInAddress = 'TestUser@testdomain.com'
                        },
                        @{
                            name = 'Test User2'
                            SignInAddress = 'TestUser2@testdomain.com'
                        }
                    )
                }}

            It 'Should return user account information for a specific user' {
                $user = Get-VSTeamAccountUser -uniquename TestUser@testdomain.com
                # Make sure it was called with the correct URI
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
                    $Uri -eq 'https://test.vssps.visualstudio.com/apiusermanagement/GetAccountUsers'
                }
                $user.name | Should Be "Test User"
            }
        }

        Context 'Get-VSTeamAccountUser for all users' {
            Mock Invoke-RestMethod { 
                return @{
                    users = @(
                        @{
                            name = 'Test User'
                            SignInAddress = 'TestUser@testdomain.com'
                        },
                        @{
                            name = 'Test User2'
                            SignInAddress = 'TestUser2@testdomain.com'
                        }
                    )
                }}

            It 'Should return user account information for 2 users' {
                $users = Get-VSTeamAccountUser
                # Make sure it was called with the correct URI
                Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
                    $Uri -eq 'https://test.vssps.visualstudio.com/apiusermanagement/GetAccountUsers'
                }
                $users.Count | Should Be 2

            }
        }

    }

}