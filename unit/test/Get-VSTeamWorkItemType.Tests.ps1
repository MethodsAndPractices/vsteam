Set-StrictMode -Version Latest

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Private/applyTypes.ps1"
. "$here/../../Source/Public/$sut"

Describe 'VSTeamWorkItemType' {
   # Set the account to use for testing. A normal user would do this
   # using the Set-VSTeamAccount function.
   Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable
   
   # Mock the call to Get-Projects by the dynamic parameter for ProjectName
   Mock Invoke-RestMethod { return @() } -ParameterFilter {
      $Uri -like "*_apis/projects*"
   }

   # Load the mocks to create the project name dynamic parameter
   . "$PSScriptRoot\mocks\mockProjectNameDynamicParam.ps1"

   Context 'With project only' {
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
            $Uri -eq "https://dev.azure.com/test/test/_apis/wit/workitemtypes?api-version=$([VSTeamVersions]::Core)"
         }
      }
   }

   Context 'By Type with Default Project' {
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
         $Global:PSDefaultParameterValues["*:projectName"] = 'test'
         Get-VSTeamWorkItemType -WorkItemType bug

         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/test/_apis/wit/workitemtypes/bug?api-version=$([VSTeamVersions]::Core)"
         }
      }
   }

   Context 'By Type with explicit Project' {
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
         $Global:PSDefaultParameterValues.Remove("*:projectName")
         Get-VSTeamWorkItemType -ProjectName test -WorkItemType bug

         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/test/_apis/wit/workitemtypes/bug?api-version=$([VSTeamVersions]::Core)"
         }
      }
   }
}