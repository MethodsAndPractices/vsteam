Set-StrictMode -Version Latest

Get-Module VSTeam | Remove-Module -Force
Import-Module $PSScriptRoot\..\..\src\team.psm1 -Force
Import-Module $PSScriptRoot\..\..\src\projects.psm1 -Force
Import-Module $PSScriptRoot\..\..\src\workitemTypes.psm1 -Force

InModuleScope workitemTypes {
   $VSTeamVersionTable.Account = 'https://test.visualstudio.com'

   Describe 'workitemTypes' {
      Context 'Get-WorkItemTypes' {
         $obj = @{
            count = 1
            value = @{
               name          = "Test Suite"
               referenceName = "Microsoft.VSTS.WorkItemTypes.TestSuite"
               description   = "Tracks test activites for a specific feature, requirement, or user story."
               color         = "004B50"
            }
         }

         Mock Invoke-RestMethod {
            return ConvertTo-Json $obj
         }

         It 'Should return all work item types' {
            Get-VSTeamWorkItemType -ProjectName test

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://test.visualstudio.com/test/_apis/wit/workitemtypes/?api-version=$($VSTeamVersionTable.Core)"
            }
         }
      }

      Context 'Get-WorkItemTypes By Type with Default Project' {
         $obj = @{
            name          = "Bug"
            referenceName = "Microsoft.VSTS.WorkItemTypes.Bug"
            description   = "Describes a divergence between required and actual behavior, and tracks the work done to correct the defect and verify the correction."
            color         = "CC293D"
         }

         Mock Invoke-RestMethod {
            return ConvertTo-Json $obj
         }

         It 'Should return 1 work item type' {
            Set-DefaultProject test
            Get-VSTeamWorkItemType -ProjectName test -WorkItemType bug

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://test.visualstudio.com/test/_apis/wit/workitemtypes/bug?api-version=$($VSTeamVersionTable.Core)"
            }
         }
      }

      Context 'Get-WorkItemTypes By Type without Default Project' {
         $obj = @{
            name          = "Bug"
            referenceName = "Microsoft.VSTS.WorkItemTypes.Bug"
            description   = "Describes a divergence between required and actual behavior, and tracks the work done to correct the defect and verify the correction."
            color         = "CC293D"
         }

         Mock Invoke-RestMethod {
            return ConvertTo-Json $obj
         }

         It 'Should return 1 work item type' {
            Clear-DefaultProject
            Get-VSTeamWorkItemType -ProjectName test -WorkItemType bug

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://test.visualstudio.com/test/_apis/wit/workitemtypes/bug?api-version=$($VSTeamVersionTable.Core)"
            }
         }
      }
   }
}