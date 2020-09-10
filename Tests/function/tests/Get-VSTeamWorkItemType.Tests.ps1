Set-StrictMode -Version Latest

Describe 'VSTeamWorkItemType' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      $Global:PSDefaultParameterValues.Remove("*-vsteam*:projectName")

      ## Arrange
      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Core' }
   }

   Context 'Get-VSTeamWorkItemType' {
      BeforeAll {
         Mock Invoke-RestMethod { Open-SampleFile 'get-vsteamworkitemtype.json' -Json }
         Mock Invoke-RestMethod { Open-SampleFile 'bug.json' -Json } -ParameterFilter {
            $Uri -like "*bug*" 
         }
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