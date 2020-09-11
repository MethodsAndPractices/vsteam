Set-StrictMode -Version Latest

Describe 'VSTeamWorkItem' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      Mock _getInstance { return 'https://dev.azure.com/test' }
   }

   Context 'Update-VSTeamWorkItem' {
      BeforeAll {
         Mock Invoke-RestMethod { Open-SampleFile 'Get-VSTeamWorkItem-Id16.json' }
      }

      It 'Without Default Project should update work item' {
         ## Arrange
         $Global:PSDefaultParameterValues.Remove("*-vsteam*:projectName")

         ## Act
         Update-VSTeamWorkItem -Id 1 -Title Test -Force

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Patch' -and
            $Body -like '`[*' -and # Make sure the body is an array
            $Body -like '*`]' -and # Make sure the body is an array
            $ContentType -eq 'application/json-patch+json' -and
            $Uri -eq "https://dev.azure.com/test/_apis/wit/workitems/1?api-version=$(_getApiVersion Core)"
         }
      }

      It 'With Default Project should update work item' {
         ## Arrange
         $Global:PSDefaultParameterValues["*-vsteam*:projectName"] = 'test'
         
         ## Act
         Update-VSTeamWorkItem 1 -Title Test1 -Description Testing -Force

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Patch' -and
            $Body -like '`[*' -and # Make sure the body is an array
            $Body -like '*Test1*' -and
            $Body -like '*Testing*' -and
            $Body -like '*/fields/System.Title*' -and
            $Body -like '*/fields/System.Description*' -and
            $Body -like '*`]' -and # Make sure the body is an array
            $ContentType -eq 'application/json-patch+json' -and
            $Uri -eq "https://dev.azure.com/test/_apis/wit/workitems/1?api-version=$(_getApiVersion Core)"
         }
      }

      It 'With Default Project should update work item with 2 parameters and additional properties' {
         ## Arrange
         $Global:PSDefaultParameterValues["*-vsteam*:projectName"] = 'test'
         $additionalFields = @{"System.Tags" = "TestTag"; "System.AreaPath" = "Project\\MyPath" }
         
         ## Act
         Update-VSTeamWorkItem 1 -Title Test1 -Description Testing -AdditionalFields $additionalFields

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Patch' -and
            $Body -like '`[*' -and # Make sure the body is an array
            $Body -like '*Test1*' -and
            $Body -like '*Testing*' -and
            $Body -like '*/fields/System.Title*' -and
            $Body -like '*/fields/System.Description*' -and
            $Body -like '*/fields/System.Tags*' -and
            $Body -like '*/fields/System.AreaPath*' -and
            $Body -like '*`]' -and # Make sure the body is an array
            $ContentType -eq 'application/json-patch+json' -and
            $Uri -eq "https://dev.azure.com/test/_apis/wit/workitems/1?api-version=$(_getApiVersion Core)"
         }
      }

      It 'With Default Project should update work item only with 1 parameter and additional properties' {
         ## Arrange
         $Global:PSDefaultParameterValues["*-vsteam*:projectName"] = 'test'
         $additionalFields = @{"System.Tags" = "TestTag"; "System.AreaPath" = "Project\\MyPath" }

         ## Act
         Update-VSTeamWorkItem 1 -Title Test1 -AdditionalFields $additionalFields

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Patch' -and
            $Body -like '`[*' -and # Make sure the body is an array
            $Body -like '*Test1*' -and
            $Body -like '*/fields/System.Title*' -and
            $Body -like '*/fields/System.Tags*' -and
            $Body -like '*/fields/System.AreaPath*' -and
            $Body -like '*`]' -and # Make sure the body is an array
            $ContentType -eq 'application/json-patch+json' -and
            $Uri -eq "https://dev.azure.com/test/_apis/wit/workitems/1?api-version=$(_getApiVersion Core)"
         }
      }

      It 'With Default Project should update work item only with additional properties' {
         ## Arrange
         $Global:PSDefaultParameterValues["*-vsteam*:projectName"] = 'test'
         $additionalFields = @{"System.Tags" = "TestTag"; "System.AreaPath" = "Project\\MyPath" }

         ## Act
         Update-VSTeamWorkItem 1 -AdditionalFields $additionalFields

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Patch' -and
            $Body -like '`[*' -and # Make sure the body is an array
            $Body -like '*/fields/System.Tags*' -and
            $Body -like '*/fields/System.AreaPath*' -and
            $Body -like '*`]' -and # Make sure the body is an array
            $ContentType -eq 'application/json-patch+json' -and
            $Uri -eq "https://dev.azure.com/test/_apis/wit/workitems/1?api-version=$(_getApiVersion Core)"
         }
      }

      It 'With Default Project should throw exception when adding existing parameters to additional properties' {
         ## Arrange
         $Global:PSDefaultParameterValues["*-vsteam*:projectName"] = 'test'
         $additionalFields = @{"System.Title" = "Test1"; "System.AreaPath" = "Project\\TestPath" }

         ## Act / Assert
         { Update-VSTeamWorkItem 1 -Title Test1 -Description Testing -AdditionalFields $additionalFields } | Should -Throw
      }
   }
}