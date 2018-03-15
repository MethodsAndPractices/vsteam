Set-StrictMode -Version Latest

# Remove any loaded version of this module so only the files
# imported below are being tested.
Get-Module VSTeam | Remove-Module -Force

# Load the modules we want to test and any dependencies
Import-Module $PSScriptRoot\..\..\src\team.psm1 -Force
Import-Module $PSScriptRoot\..\..\src\Approvals.psm1 -Force

# The InModuleScope command allows you to perform white-box unit testing on the 
# internal (non-exported) code of a Script Module.
InModuleScope Approvals {

   # Set the account to use for testing. A normal user would do this
   # using the Add-VSTeamAccount function.
   $VSTeamVersionTable.Account = 'https://test.visualstudio.com'

   Describe 'Approvals' {

      # Load the mocks to create the project name dynamic parameter
      . "$PSScriptRoot\mockProjectNameDynamicParamNoPSet.ps1"

      Context 'Get-VSTeamApproval handles exception' {
         
         # Arrange
         Mock _handleException -Verifiable
         Mock Invoke-RestMethod { throw 'testing error handling' }

         # Act
         Get-VSTeamApproval -ProjectName project
         
         It 'should return approvals' {

            # Assert
            Assert-VerifiableMocks
         }
      }

      Context 'Get-VSTeamApproval' {
         Mock Invoke-RestMethod {            
            return @{
               count = 1
               value = @(
                  @{
                     id       = 1
                     revision = 1
                     approver = @{
                        id          = 'c1f4b9a6-aee1-41f9-a2e0-070a79973ae9'
                        displayName = 'Test User'
                     }
                  }
               )
            }}

         Get-VSTeamApproval -projectName project
         
         It 'should return approvals' {
            Assert-MockCalled Invoke-RestMethod -Exactly -Scope Context -Times 1 `
               -ParameterFilter { 
               $Uri -eq "https://test.vsrm.visualstudio.com/project/_apis/release/approvals/?api-version=$($VSTeamVersionTable.Release)"
            }
         }
      }

      Context 'Get-VSTeamApproval with AssignedToFilter' {
            Mock Invoke-RestMethod {            
               return @{
                  count = 1
                  value = @(
                     @{
                        id       = 1
                        revision = 1
                        approver = @{
                           id          = 'c1f4b9a6-aee1-41f9-a2e0-070a79973ae9'
                           displayName = 'Test User'
                        }
                     }
                  )
               }}
   
            Get-VSTeamApproval -projectName project -AssignedToFilter 'Chuck Reinhart'
            
            It 'should return approvals' {
               Assert-MockCalled Invoke-RestMethod -Exactly -Scope Context -Times 1 `
                  -ParameterFilter { 
                  $Uri -eq "https://test.vsrm.visualstudio.com/project/_apis/release/approvals/?api-version=$($VSTeamVersionTable.Release)&assignedtoFilter=Chuck%20Reinhart&includeMyGroupApprovals=true"
               }
            }
         }

      # This makes sure the alias is working
      Context 'Get-Approval' {
         Mock _useWindowsAuthenticationOnPremise { return $true }
         Mock Invoke-RestMethod { return @{
               count = 1
               value = @(
                  @{
                     id       = 1
                     revision = 1
                     approver = @{
                        id          = 'c1f4b9a6-aee1-41f9-a2e0-070a79973ae9'
                        displayName = 'Test User'
                     }
                  }
               )
            }}
        
         Get-Approval -projectName project
        
         It 'should return approvals' {
            Assert-MockCalled Invoke-RestMethod -Exactly -Scope Context -Times 1 `
               -ParameterFilter { 
               $Uri -eq "https://test.vsrm.visualstudio.com/project/_apis/release/approvals/?api-version=$($VSTeamVersionTable.Release)"
            }
         }
      }

      Context 'Set-VSTeamApproval' {
         Mock Invoke-RestMethod { return @{
               id       = 1
               revision = 1
               approver = @{
                  id          = 'c1f4b9a6-aee1-41f9-a2e0-070a79973ae9'
                  displayName = 'Test User'
               }
            }}

         Set-VSTeamApproval -projectName project -Id 1 -Status Rejected -Force

         It 'should set approval' {
            Assert-MockCalled Invoke-RestMethod -Exactly -Scope Context -Times 1 `
               -ParameterFilter { 
               $Method -eq 'Patch' -and
               $Uri -eq "https://test.vsrm.visualstudio.com/project/_apis/release/approvals/1?api-version=$($VSTeamVersionTable.Release)"
            }
         }
      }

      Context 'Set-VSTeamApproval handles exception' {
         Mock _handleException -Verifiable
         Mock Invoke-RestMethod { throw 'testing error handling' }

         Set-VSTeamApproval -projectName project -Id 1 -Status Rejected -Force

         It 'should set approval' {
            Assert-MockCalled Invoke-RestMethod -Exactly -Scope Context -Times 1 `
               -ParameterFilter { 
               $Uri -eq "https://test.vsrm.visualstudio.com/project/_apis/release/approvals/1?api-version=$($VSTeamVersionTable.Release)"
            }
         }
      }

      Context 'Set-Approval' {
         Mock _useWindowsAuthenticationOnPremise { return $true }
         Mock Invoke-RestMethod { return @{
               id       = 1
               revision = 1
               approver = @{
                  id          = 'c1f4b9a6-aee1-41f9-a2e0-070a79973ae9'
                  displayName = 'Test User'
               }
            }}

         Set-Approval -projectName project -Id 1 -Status Rejected -Force
            
         It 'should set approval' {
            Assert-MockCalled Invoke-RestMethod -Exactly -Scope Context -Times 1 `
               -ParameterFilter { 
               $Method -eq 'Patch' -and
               $Uri -eq "https://test.vsrm.visualstudio.com/project/_apis/release/approvals/1?api-version=$($VSTeamVersionTable.Release)"
            }
         }
      }

      Context 'Show-VSTeamApproval' {
         Mock _showInBrowser -Verifiable
         
         Show-VSTeamApproval -projectName project -ReleaseDefinitionId 1

         It 'should open in browser' {
            Assert-VerifiableMocks
         }
      }
   }
}