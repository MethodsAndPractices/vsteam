Set-StrictMode -Version Latest

Get-Module VSTeam | Remove-Module -Force
Import-Module $PSScriptRoot\..\..\src\team.psm1 -Force
Import-Module $PSScriptRoot\..\..\src\workitems.psm1 -Force

InModuleScope workitems {
   $VSTeamVersionTable.Account = 'https://test.visualstudio.com'

   Describe 'workitems' {
      . "$PSScriptRoot\mockProjectNameDynamicParamNoPSet.ps1"

      $obj = @{
         id  = 47
         rev = 1
         url = "https://test.visualstudio.com/_apis/wit/workItems/47"
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
               $Uri -eq "https://test.visualstudio.com/test/_apis/wit/workitems/`$Task?api-version=$($VSTeamVersionTable.Core)"
            }
         }

         It 'With Default Project should add work item' {
            $Global:PSDefaultParameterValues["*:projectName"] = 'test'
            Add-VSTeamWorkItem -ProjectName test -WorkItemType Task -Title Test

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Method -eq 'Post' -and
               $ContentType -eq 'application/json-patch+json' -and
               $Uri -eq "https://test.visualstudio.com/test/_apis/wit/workitems/`$Task?api-version=$($VSTeamVersionTable.Core)"
            }
         }
      }

      Context 'Show-VSTeamWorkItem' {
         Mock _showInBrowser { }

         it 'should return url for mine' {
            Show-VSTeamWorkItem -projectName project -Id 15

            Assert-MockCalled _showInBrowser -Exactly -Scope It -Times 1 -ParameterFilter { $url -eq 'https://test.visualstudio.com/project/_workitems/edit/15' }
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
            Get-VSTeamWorkItem -ProjectName test -Ids 47,48

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://test.visualstudio.com/test/_apis/wit/workitems/?api-version=$($VSTeamVersionTable.Core)&ids=47,48&`$Expand=None&errorPolicy=Fail"
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
               $Uri -eq "https://test.visualstudio.com/test/_apis/wit/workitems/47?api-version=$($VSTeamVersionTable.Core)&`$Expand=None"
            }
         }
      }
   }
}