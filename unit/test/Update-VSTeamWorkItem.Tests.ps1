Set-StrictMode -Version Latest

Describe 'VSTeamWorkItem' {
   BeforeAll {
      Add-Type -Path "$PSScriptRoot/../../dist/bin/vsteam-lib.dll"
      
      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

      
      . "$PSScriptRoot/../../Source/Private/applyTypes.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"

      # Prime the project cache with an empty list. This will make sure
      # any project name used will pass validation and Get-VSTeamProject 
      # will not need to be called.
      [vsteam_lib.ProjectCache]::Update([string[]]@())

      Mock _getInstance { return 'https://dev.azure.com/test' }

      $obj = @{
         id  = 47
         rev = 1
         url = "https://dev.azure.com/test/_apis/wit/workItems/47"
      }
   }

   Context 'Update-VSTeamWorkItem' {
      BeforeAll {
         Mock Invoke-RestMethod {
            # If this test fails uncomment the line below to see how the mock was called.
            # Write-Host $args

            return $obj
         }
      }

      It 'Without Default Project should update work item' {
         $Global:PSDefaultParameterValues.Remove("*-vsteam*:projectName")
         Update-VSTeamWorkItem -Id 1 -Title Test -Force

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Patch' -and
            $Body -like '`[*' -and # Make sure the body is an array
            $Body -like '*`]' -and # Make sure the body is an array
            $ContentType -eq 'application/json-patch+json' -and
            $Uri -eq "https://dev.azure.com/test/_apis/wit/workitems/1?api-version=$(_getApiVersion Core)"
         }
      }

      It 'With Default Project should update work item' {
         $Global:PSDefaultParameterValues["*-vsteam*:projectName"] = 'test'
         Update-VSTeamWorkItem 1 -Title Test1 -Description Testing -Force

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
         $Global:PSDefaultParameterValues["*-vsteam*:projectName"] = 'test'

         $additionalFields = @{"System.Tags" = "TestTag"; "System.AreaPath" = "Project\\MyPath" }
         Update-VSTeamWorkItem 1 -Title Test1 -Description Testing -AdditionalFields $additionalFields

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
         $Global:PSDefaultParameterValues["*-vsteam*:projectName"] = 'test'

         $additionalFields = @{"System.Tags" = "TestTag"; "System.AreaPath" = "Project\\MyPath" }
         Update-VSTeamWorkItem 1 -Title Test1 -AdditionalFields $additionalFields

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
         $Global:PSDefaultParameterValues["*-vsteam*:projectName"] = 'test'

         $additionalFields = @{"System.Tags" = "TestTag"; "System.AreaPath" = "Project\\MyPath" }
         Update-VSTeamWorkItem 1 -AdditionalFields $additionalFields

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
         $Global:PSDefaultParameterValues["*-vsteam*:projectName"] = 'test'

         $additionalFields = @{"System.Title" = "Test1"; "System.AreaPath" = "Project\\TestPath" }
         { Update-VSTeamWorkItem 1 -Title Test1 -Description Testing -AdditionalFields $additionalFields } | Should -Throw
      }
   }
}