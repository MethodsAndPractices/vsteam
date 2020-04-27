Set-StrictMode -Version Latest

#region include
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Private/applyTypes.ps1"
. "$here/../../Source/Public/$sut"
#endregion

Describe 'VSTeamWorkItemType' {
   ## Arrange
   # Load the mocks to create the project name dynamic parameter
   . "$PSScriptRoot\mocks\mockProjectNameDynamicParam.ps1"

   # Set the account to use for testing. A normal user would do this
   # using the Set-VSTeamAccount function.
   Mock _getInstance { return 'https://dev.azure.com/test' }
   Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Core' }


   Context 'Get-VSTeamWorkItemType' {
      $testSuite = @{
         count = 1
         value = @{
            name          = "Test Suite"
            referenceName = "Microsoft.VSTS.WorkItemTypes.TestSuite"
            description   = "Tracks test activites for a specific feature, requirement, or user story."
            color         = "004B50"
         }
      }

      $bug = @{
         name          = "Bug"
         referenceName = "Microsoft.VSTS.WorkItemTypes.Bug"
         description   = "Describes a divergence between required and actual behavior, and tracks the work done to correct the defect and verify the correction."
         color         = "CC293D"
      }

      Mock Invoke-RestMethod { return ConvertTo-Json $testSuite }
      Mock Invoke-RestMethod { return ConvertTo-Json $bug } -ParameterFilter{ $Uri -like "*bug*" }

      It 'with project only should return all work item types' {
         ## Act
         Get-VSTeamWorkItemType -ProjectName test

         ## Assert
         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/test/_apis/wit/workitemtypes?api-version=$(_getApiVersion Core)"
         }
      }

      It 'by type with default project should return 1 work item type' {
         ## Arrange
         $Global:PSDefaultParameterValues["*:projectName"] = 'test'
         
         ## Act
         Get-VSTeamWorkItemType -WorkItemType bug

         ## Assert
         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/test/_apis/wit/workitemtypes/bug?api-version=$(_getApiVersion Core)"
         }
      }

      It 'by type with explicit project should return 1 work item type' {
         ## Arrange
         $Global:PSDefaultParameterValues.Remove("*:projectName")

         ## Act
         Get-VSTeamWorkItemType -ProjectName test -WorkItemType bug

         ## Assert
         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/test/_apis/wit/workitemtypes/bug?api-version=$(_getApiVersion Core)"
         }
      }
   }
}