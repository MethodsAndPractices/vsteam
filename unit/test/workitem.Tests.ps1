Set-StrictMode -Version Latest

InModuleScope workitems {
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

      $collection = @{
         count = 1
         value = @($obj)
      }

      Context 'Add-WorkItem' {
         Mock Invoke-RestMethod {
            return $obj
         }

         It 'Without Default Project should add work item' {
            $Global:PSDefaultParameterValues.Remove("*:projectName")
            Add-VSTeamWorkItem -ProjectName test -WorkItemType Task -Title Test

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Method -eq 'Post' -and
               $ContentType -eq 'application/json-patch+json' -and
               $Uri -eq "https://dev.azure.com/test/test/_apis/wit/workitems/`$Task?api-version=$([VSTeamVersions]::Core)"
            }
         }

         It 'With Default Project should add work item' {
            $Global:PSDefaultParameterValues["*:projectName"] = 'test'
            Add-VSTeamWorkItem -ProjectName test -WorkItemType Task -Title Test

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Method -eq 'Post' -and
               $ContentType -eq 'application/json-patch+json' -and
               $Uri -eq "https://dev.azure.com/test/test/_apis/wit/workitems/`$Task?api-version=$([VSTeamVersions]::Core)"
            }
         }
      }

      Context 'Show-VSTeamWorkItem' {
         Mock Show-Browser { }

         it 'should return url for mine' {
            Show-VSTeamWorkItem -projectName project -Id 15

            Assert-MockCalled Show-Browser -Exactly -Scope It -Times 1 -ParameterFilter { $url -eq 'https://dev.azure.com/test/project/_workitems/edit/15' }
         }
      }

      Context 'Get-WorkItem' {       

         It 'Without Default Project should add work item' {
            Mock Invoke-RestMethod {
               # If this test fails uncomment the line below to see how the mock was called.
               # Write-Host $args
               
               return $collection
            }

            $Global:PSDefaultParameterValues.Remove("*:projectName")
            Get-VSTeamWorkItem -ProjectName test -Ids 47, 48

            # With PowerShell core the order of the query string is not the 
            # same from run to run!  So instead of testing the entire string
            # matches I have to search for the portions I expect but can't
            # assume the order. 
            # The general string should look like this:
            # https://dev.azure.com/test/test/_apis/wit/workitems/?api-version=$([VSTeamVersions]::Core)&ids=47,48&`$Expand=None&errorPolicy=Fail
            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -like "*https://dev.azure.com/test/test/_apis/wit/workitems/*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Core)*" -and
               $Uri -like "*ids=47,48*" -and
               $Uri -like "*`$Expand=None*" -and
               $Uri -like "*errorPolicy=Fail*"
            }
         }

         It 'With Default Project should add work item' {
            Mock Invoke-RestMethod {
               # If this test fails uncomment the line below to see how the mock was called.
               # Write-Host $args
               return $obj
            }

            $Global:PSDefaultParameterValues["*:projectName"] = 'test'
            Get-VSTeamWorkItem -ProjectName test -Id 47

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/test/_apis/wit/workitems/47?api-version=$([VSTeamVersions]::Core)&`$Expand=None"
            }
         }
      }
   }
}