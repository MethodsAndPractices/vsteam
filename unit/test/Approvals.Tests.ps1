Set-StrictMode -Version Latest

Get-Module team | Remove-Module -Force
# Required for the dynamic parameter
Import-Module $PSScriptRoot\..\..\src\Approvals.psm1 -Force

InModuleScope Approvals {
   $env:TEAM_ACCT = 'https://test.visualstudio.com'

   Describe 'Approvals' {
      . "$PSScriptRoot\mockProjectNameDynamicParamNoPSet.ps1"

      Context 'Get-VSTeamApproval' {
         Mock Invoke-RestMethod { return @{
               count=1
               value=@(
                  @{
                     id=1
                     revision=1
                     approver=@{
                        id='c1f4b9a6-aee1-41f9-a2e0-070a79973ae9'
                        displayName='Test User'
                     }
                  }
               )
            }}

         It 'should return approvals' {
            Get-VSTeamApproval -projectName project

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter { $Uri -eq 'https://test.vsrm.visualstudio.com/project/_apis/release/approvals?api-version=3.0-preview.1' }
         }
      }

      # This makes sure the alias is working
      Context 'Get-Approval' {
         Mock Invoke-RestMethod { return @{
               count=1
               value=@(
                  @{
                     id=1
                     revision=1
                     approver=@{
                        id='c1f4b9a6-aee1-41f9-a2e0-070a79973ae9'
                        displayName='Test User'
                     }
                  }
               )
            }}

         It 'should return approvals' {
            Get-Approval -projectName project

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter { $Uri -eq 'https://test.vsrm.visualstudio.com/project/_apis/release/approvals?api-version=3.0-preview.1' }
         }
      }

      Context 'Set-VSTeamApproval' {
         Mock Invoke-RestMethod { return @{
               id=1
               revision=1
               approver=@{
                  id='c1f4b9a6-aee1-41f9-a2e0-070a79973ae9'
                  displayName='Test User'
               }
            }}

         It 'should set approval' {
            Set-VSTeamApproval -projectName project -Id 1 -Status Rejected -Force

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter { $Uri -eq 'https://test.vsrm.visualstudio.com/project/_apis/release/approvals/1?api-version=3.0-preview.1' }
         }
      }

      Context 'Set-Approval' {
         Mock Invoke-RestMethod { return @{
               id=1
               revision=1
               approver=@{
                  id='c1f4b9a6-aee1-41f9-a2e0-070a79973ae9'
                  displayName='Test User'
               }
            }}

         It 'should set approval' {
            Set-Approval -projectName project -Id 1 -Status Rejected -Force

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter { $Uri -eq 'https://test.vsrm.visualstudio.com/project/_apis/release/approvals/1?api-version=3.0-preview.1' }
         }
      }
   }
}