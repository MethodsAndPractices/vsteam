Set-StrictMode -Version Latest

Describe 'VSTeamWorkItem' {
   BeforeAll {
      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProjectCache.ps1"
      . "$PSScriptRoot/../../Source/Classes/WorkItemTypeCompleter.ps1"
      . "$PSScriptRoot/../../Source/Classes/WorkItemTypeValidateAttribute.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectCompleter.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectValidateAttribute.ps1"
      . "$PSScriptRoot/../../Source/Private/applyTypes.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"
      
      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Core' }

      # Mock the call to Get-Projects by the dynamic parameter for ProjectName
      Mock Invoke-RestMethod { return @() } -ParameterFilter { $Uri -like "*_apis/projects*" }

      $obj = @{
         id  = 47
         rev = 1
         url = "https://dev.azure.com/test/_apis/wit/workItems/47"
      }

      Mock Invoke-RestMethod {
         # If this test fails uncomment the line below to see how the mock was called.
         # Write-Host $args

         return $obj
      }
   }

   Context 'Add-VSTeamWorkItem' {
      It 'Without Default Project should add work item' {
         $Global:PSDefaultParameterValues.Remove("*-vsteam*:projectName")
         Add-VSTeamWorkItem -ProjectName test -WorkItemType Task -Title Test

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Post' -and
            $Body -like '`[*' -and # Make sure the body is an array
            $Body -like '*`]' -and # Make sure the body is an array
            $ContentType -eq 'application/json-patch+json' -and
            $Uri -eq "https://dev.azure.com/test/test/_apis/wit/workitems/`$Task?api-version=$(_getApiVersion Core)"
         }
      }

      It 'With Default Project should add work item' {
         $Global:PSDefaultParameterValues["*-vsteam*:projectName"] = 'test'
         Add-VSTeamWorkItem -ProjectName test -WorkItemType Task -Title Test1 -Description Testing

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Post' -and
            $Body -like '`[*' -and # Make sure the body is an array
            $Body -like '*Test1*' -and
            $Body -like '*Testing*' -and
            $Body -like '*/fields/System.Title*' -and
            $Body -like '*/fields/System.Description*' -and
            $Body -like '*`]' -and # Make sure the body is an array
            $ContentType -eq 'application/json-patch+json' -and
            $Uri -eq "https://dev.azure.com/test/test/_apis/wit/workitems/`$Task?api-version=$(_getApiVersion Core)"
         }
      }

      It 'With Default Project should add work item with parent' {
         $Global:PSDefaultParameterValues["*-vsteam*:projectName"] = 'test'
         Add-VSTeamWorkItem -ProjectName test -WorkItemType Task -Title Test1 -Description Testing -ParentId 25

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Post' -and
            $Body -like '`[*' -and # Make sure the body is an array
            $Body -like '*Test1*' -and
            $Body -like '*Testing*' -and
            $Body -like '*/fields/System.Title*' -and
            $Body -like '*/fields/System.Description*' -and
            $Body -like '*/relations/-*' -and
            $Body -like '*_apis/wit/workitems/25*' -and
            $Body -like '*System.LinkTypes.Hierarchy-Reverse*' -and
            $Body -like '*`]' -and # Make sure the body is an array
            $ContentType -eq 'application/json-patch+json' -and
            $Uri -eq "https://dev.azure.com/test/test/_apis/wit/workitems/`$Task?api-version=$(_getApiVersion Core)"
         }
      }

      It 'With Default Project should add work item only with additional properties and parent id' {
         $Global:PSDefaultParameterValues["*-vsteam*:projectName"] = 'test'

         $additionalFields = @{"System.Tags" = "TestTag"; "System.AreaPath" = "Project\\MyPath" }
         Add-VSTeamWorkItem -ProjectName test -WorkItemType Task -Title Test1 -Description Testing -ParentId 25 -AdditionalFields $additionalFields

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Post' -and
            $Body -like '`[*' -and # Make sure the body is an array
            $Body -like '*Test1*' -and
            $Body -like '*Testing*' -and
            $Body -like '*/fields/System.Title*' -and
            $Body -like '*/fields/System.Description*' -and
            $Body -like '*/relations/-*' -and
            $Body -like '*_apis/wit/workitems/25*' -and
            $Body -like '*/fields/System.Tags*' -and
            $Body -like '*/fields/System.AreaPath*' -and
            $Body -like '*`]' -and # Make sure the body is an array
            $ContentType -eq 'application/json-patch+json' -and
            $Uri -eq "https://dev.azure.com/test/test/_apis/wit/workitems/`$Task?api-version=$(_getApiVersion Core)"
         }
      }

      It 'With Default Project should add work item only with additional properties' {
         $Global:PSDefaultParameterValues["*-vsteam*:projectName"] = 'test'

         $additionalFields = @{"System.Tags" = "TestTag"; "System.AreaPath" = "Project\\MyPath" }
         Add-VSTeamWorkItem -ProjectName test -WorkItemType Task -Title Test1 -AdditionalFields $additionalFields

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Post' -and
            $Body -like '`[*' -and # Make sure the body is an array
            $Body -like '*Test1*' -and
            $Body -like '*/fields/System.Title*' -and
            $Body -like '*/fields/System.Tags*' -and
            $Body -like '*/fields/System.AreaPath*' -and
            $Body -like '*`]' -and # Make sure the body is an array
            $ContentType -eq 'application/json-patch+json' -and
            $Uri -eq "https://dev.azure.com/test/test/_apis/wit/workitems/`$Task?api-version=$(_getApiVersion Core)"
         }
      }

      It 'With Default Project should throw exception when adding existing parameters to additional properties and parent id' {
         $Global:PSDefaultParameterValues["*-vsteam*:projectName"] = 'test'

         $additionalFields = @{"System.Title" = "Test1"; "System.AreaPath" = "Project\\TestPath" }
         { Add-VSTeamWorkItem -ProjectName test -WorkItemType Task -Title Test1 -Description Testing -ParentId 25 -AdditionalFields $additionalFields } | Should -Throw
      }
   }
}
