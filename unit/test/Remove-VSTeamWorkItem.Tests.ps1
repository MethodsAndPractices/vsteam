Set-StrictMode -Version Latest

InModuleScope VSTeam {
   [VSTeamVersions]::Account = 'https://dev.azure.com/test'

   Describe 'workitems' {
      # Mock the call to Get-Projects by the dynamic parameter for ProjectName
      Mock Invoke-RestMethod { return @() } -ParameterFilter {
         $Uri -like "*_apis/projects*"
      }

      . "$PSScriptRoot\mocks\mockProjectNameDynamicParamNoPSet.ps1"

      $obj = @{
         id  = 47
         rev = 1
         url = "https://dev.azure.com/test/_apis/wit/workItems/47"
      }

      $objDeleted = @{
         id          = 47
         name        = "Test Work Item 47"
         deletedBy   = "Theobald Test <theobald.test@contoso.com>"
         deletedDate = "10/19/2019 9:08:48 PM"
         code        = 200
         resource    = $obj
      }

      $collectionDeleted = @(
         $objDeleted
      )

      Context 'Remove-WorkItem' {

         It 'Should delete single work item' {
            Mock Invoke-RestMethod {
               # If this test fails uncomment the line below to see how the mock was called.
               #Write-Host $args

               return $collectionDeleted
            }

            Remove-VSTeamWorkItem -Id 47 -Force

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -like "*https://dev.azure.com/test/_apis/wit/workitems*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Core)*" -and
               $Uri -like "*workitems/47*"
            }
         }

         It 'Should throw single work item with id equals $null' {
            { Remove-VSTeamWorkItem -Id $null } | Should -Throw
         }

         It 'Should delete multipe work items' {
            Mock Invoke-RestMethod {
               # If this test fails uncomment the line below to see how the mock was called.
               #Write-Host $args

               return $collectionDeleted
            }

            Remove-VSTeamWorkItem -Id 47, 48 -Force

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 2 -ParameterFilter {
               $Uri -like "*https://dev.azure.com/test/_apis/wit/workitems*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Core)*" -and
               ($Uri -like "*workitems/47*" -or $Uri -like "*workitems/48*")
            }
         }

         It 'Single Work Item Should be deleted permanently' {
            Mock Invoke-RestMethod {
               # If this test fails uncomment the line below to see how the mock was called.
               #Write-Host $args

               return $collectionDeleted
            }

            Remove-VSTeamWorkItem -Id 47, 48 -Destroy -Force

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 2 -ParameterFilter {
               $Uri -like "*https://dev.azure.com/test/_apis/wit/workitems*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Core)*" -and
               ($Uri -like "*workitems/47*" -or $Uri -like "*workitems/48*") -and
               $Uri -like "*destroy=True*"
            }
         }
      }
   }
}