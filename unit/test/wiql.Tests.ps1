Set-StrictMode -Version Latest

$env:Testing=$true
InModuleScope VSTeam {
   [VSTeamVersions]::Account = 'https://dev.azure.com/test'

   Describe 'wiql' {
      # Mock the call to Get-Projects by the dynamic parameter for ProjectName
      Mock Invoke-RestMethod { return @() } -ParameterFilter {
         $Uri -like "*_apis/projects*"
      }

      . "$PSScriptRoot\mocks\mockProjectNameDynamicParamNoPSet.ps1"

      $workItem = @{
         id  = 47
         url = "https://dev.azure.com/test/_apis/wit/workItems/47"
      }

      $column = @{
         referenceName = "System.Id"
         name          = "ID"
         url           = "https://dev.azure.com/razorspoint-test/_apis/wit/fields/System.Id"
      }

      $sortColumn = @{
         field      = $column
         descending = $false
      }

      $wiqlResult = @{
         querytype       = "flat"
         queryResultType = "worItem"
         asOf            = "2019-10-03T18:35:09.117Z"
         columns         = @($column)
         sortColumns     = @($sortColumn)
      workItems       = @($workItem, $workItem)
      }

      $expandedWorkItems = @($workItem, $workItem)


      Context 'Get-Wiql' {
         Mock Invoke-RestMethod {
            # If this test fails uncomment the line below to see how the mock was called.
            # Write-Host $args

            return $wiqlResult
         }

         # function is mocked because it is used when switch 'Expanded' is being used.
         Mock Get-VSTeamWorkItem {
            # If this test fails uncomment the line below to see how the mock was called.
            # Write-Host $args

            return $expandedWorkItems
         }

         It 'Get work items with custom WIQL query' {
            $Global:PSDefaultParameterValues.Remove("*:projectName")
            $wiqlQuery = "Select [System.Id], [System.Title], [System.State] From WorkItems"
            Get-VSTeamWiql -ProjectName "test" -Team "test team" -Query $wiqlQuery

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Method -eq 'Post' -and
               $Body -like '`{*' -and # Make sure the body is an object
               $Body -like "*[System.Id]*" -and
               $Body -like "*[System.Title]*" -and
               $Body -like "*[System.State]*" -and
               $Body -like '*`}' -and # Make sure the body is an object
               $ContentType -eq 'application/json' -and
               $Uri -eq "https://dev.azure.com/test/test/test team/_apis/wit/wiql?api-version=$([VSTeamVersions]::Core)&`$top=100"
            }
         }

         It 'Get work items with custom WIQL query with -Top 250' {
            $Global:PSDefaultParameterValues.Remove("*:projectName")
            $wiqlQuery = "Select [System.Id], [System.Title], [System.State] From WorkItems"
            Get-VSTeamWiql -ProjectName "test" -Team "test team" -Query $wiqlQuery -Top 250

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Method -eq 'Post' -and
               $Body -like '`{*' -and # Make sure the body is an object
               $Body -like "*[System.Id]*" -and
               $Body -like "*[System.Title]*" -and
               $Body -like "*[System.State]*" -and
               $Body -like '*`}' -and # Make sure the body is an object
               $ContentType -eq 'application/json' -and
               $Uri -eq "https://dev.azure.com/test/test/test team/_apis/wit/wiql?api-version=$([VSTeamVersions]::Core)&`$top=250"
            }
         }

         It 'Get work items with custom WIQL query with -Top 0' {
            $Global:PSDefaultParameterValues.Remove("*:projectName")
            $wiqlQuery = "Select [System.Id], [System.Title], [System.State] From WorkItems"
            Get-VSTeamWiql -ProjectName "test" -Team "test team" -Query $wiqlQuery -Top 0

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Method -eq 'Post' -and
               $Body -like '`{*' -and # Make sure the body is an object
               $Body -like "*[System.Id]*" -and
               $Body -like "*[System.Title]*" -and
               $Body -like "*[System.State]*" -and
               $Body -like '*`}' -and # Make sure the body is an object
               $ContentType -eq 'application/json' -and
               $Uri -eq "https://dev.azure.com/test/test/test team/_apis/wit/wiql?api-version=$([VSTeamVersions]::Core)"
            }
         }

         It 'Get work items with custom WIQL query with expanded work items' {
            $Global:PSDefaultParameterValues.Remove("*:projectName")
            $wiqlQuery = "Select [System.Id], [System.Title], [System.State] From WorkItems"
            Get-VSTeamWiql -ProjectName "test" -Team "test team" -Query $wiqlQuery -Expand

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Method -eq 'Post' -and
               $Body -like '`{*' -and # Make sure the body is an object
               $Body -like "*[System.Id]*" -and
               $Body -like "*[System.Title]*" -and
               $Body -like "*[System.State]*" -and
               $Body -like '*`}' -and # Make sure the body is an object
               $ContentType -eq 'application/json' -and
               $Uri -eq "https://dev.azure.com/test/test/test team/_apis/wit/wiql?api-version=$([VSTeamVersions]::Core)&`$top=100"
            }
         }

         It 'Get work items with custom WIQL query with time precision' {
            $Global:PSDefaultParameterValues.Remove("*:projectName")
            $wiqlQuery = "Select [System.Id], [System.Title], [System.State] From WorkItems"
            Get-VSTeamWiql -ProjectName "test" -Team "test team" -Query $wiqlQuery -TimePrecision

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Method -eq 'Post' -and
               $Body -like '`{*' -and # Make sure the body is an object
               $Body -like "*[System.Id]*" -and
               $Body -like "*[System.Title]*" -and
               $Body -like "*[System.State]*" -and
               $Body -like '*`}' -and # Make sure the body is an object
               $ContentType -eq 'application/json' -and
               $Uri -like "*timePrecision=True*"
               $Uri -like "*`$top=100*"
               $Uri -like "https://dev.azure.com/test/test/test team/_apis/wit/wiql?api-version=$([VSTeamVersions]::Core)*"
            }
         }

         It 'Get work items with query ID query' {
            $Global:PSDefaultParameterValues.Remove("*:projectName")
            Get-VSTeamWiql -ProjectName "test" -Team "test team" -Id 1

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/test/test team/_apis/wit/wiql/1?api-version=$([VSTeamVersions]::Core)&`$top=100"
            }
         }

         It 'Get work items with query ID query with expanded work items' {
            $Global:PSDefaultParameterValues.Remove("*:projectName")
            Get-VSTeamWiql -ProjectName "test" -Team "test team" -Id 1 -Expand

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/test/test team/_apis/wit/wiql/1?api-version=$([VSTeamVersions]::Core)&`$top=100"
            }
         }
      }
   }
}