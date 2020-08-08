Set-StrictMode -Version Latest

Describe 'VSTeamWorkItemType' {
   BeforeAll {
      Add-Type -Path "$PSScriptRoot/../../dist/bin/vsteam-lib.dll"
      
      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")
      
      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Classes/WorkItemTypeCompleter.ps1"
      . "$PSScriptRoot/../../Source/Classes/WorkItemTypeValidateAttribute.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Private/applyTypes.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamProject.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"

      # Invalidate the cache to force a call to Get-VSTeamProject so the
      # test can control what is returned.
      [vsteam_lib.ProjectCache]::Invalidate()
      Mock Get-VSTeamProject { return @(@{Name = "VSTeamWorkItemType"}) }

      ## Arrange
      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Core' }

      $sampleFile = $(Get-Content "$PSScriptRoot\sampleFiles\get-vsteamworkitemtype.json" -Raw)
   }

   Context 'Get-VSTeamWorkItemType' {
      BeforeAll {
         $bug = @{
            name          = "Bug"
            referenceName = "Microsoft.VSTS.WorkItemTypes.Bug"
            description   = "Describes a divergence between required and actual behavior, and tracks the work done to correct the defect and verify the correction."
            color         = "CC293D"
         }

         Mock Invoke-RestMethod { return ConvertTo-Json $sampleFile }
         Mock Invoke-RestMethod { return ConvertTo-Json $bug } -ParameterFilter { $Uri -like "*bug*" }
      }

      It 'with project only should return all work item types' {
         ## Act
         Get-VSTeamWorkItemType -ProjectName VSTeamWorkItemType

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/VSTeamWorkItemType/_apis/wit/workitemtypes?api-version=$(_getApiVersion Core)"
         }
      }

      It 'by type with default project should return 1 work item type' {
         ## Arrange
         $Global:PSDefaultParameterValues["*-vsteam*:projectName"] = 'VSTeamWorkItemType'

         ## Act
         Get-VSTeamWorkItemType -WorkItemType bug

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/VSTeamWorkItemType/_apis/wit/workitemtypes/bug?api-version=$(_getApiVersion Core)"
         }
      }

      It 'by type with explicit project should return 1 work item type' {
         ## Arrange
         $Global:PSDefaultParameterValues.Remove("*-vsteam*:projectName")

         ## Act
         Get-VSTeamWorkItemType -ProjectName VSTeamWorkItemType -WorkItemType bug

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/VSTeamWorkItemType/_apis/wit/workitemtypes/bug?api-version=$(_getApiVersion Core)"
         }
      }
   }
}