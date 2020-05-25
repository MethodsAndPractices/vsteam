Set-StrictMode -Version Latest

Describe 'VSTeamWiql' {
   BeforeAll {
      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProjectCache.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectValidateAttribute.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectCompleter.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamQueryCache.ps1"
      . "$PSScriptRoot/../../Source/Classes/QueryCompleter.ps1"
      . "$PSScriptRoot/../../Source/Classes/QueryTransformToIDAttribute.ps1"
      . "$PSScriptRoot/../../Source/Private/applyTypes.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamWorkItem.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"

      Mock _getInstance { return 'https://dev.azure.com/test' }

      # Mock the call to Get-Projects by the dynamic parameter for ProjectName
      Mock Invoke-RestMethod { return @() } -ParameterFilter { $Uri -like "*_apis/projects*" }

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

      $expandedWorkItems = @{
         count = 1
         value = @($workItem, $workItem)
      }
   }

   Context 'Get-VSTeamWiql' {
      BeforeAll {
         Mock Invoke-RestMethod {
            # If this test fails uncomment the line below to see how the mock was called.
            # Write-Host $args

            # result is returned and -Expand is specified, the work items field is overwritten
            # If $wiqlResult is defined once (like column, and work item) the second expand has a problem
            $wiqlResult = @{
               querytype       = "flat"
               queryTypeResult = "workItem"
               asOf            = "2019-10-03T18:35:09.117Z"
               columns         = @($column)
               sortColumns     = @($sortColumn)
               workItems       = @($workItem, $workItem)
            }
            return $wiqlResult
         }

         # function is mocked because it is used when switch 'Expanded' is being used.
         Mock Get-VSTeamWorkItem {
            # If this test fails uncomment the line below to see how the mock was called.
            # Write-Host $args

            return $expandedWorkItems
         }

         $Global:PSDefaultParameterValues.Remove("*-vsteam*:projectName")
      }

      It 'Get work items with custom WIQL query' {
         $wiqlQuery = "Select [System.Id], [System.Title], [System.State] From WorkItems"
         Get-VSTeamWiql -ProjectName "test" -Team "test team" -Query $wiqlQuery

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Post' -and
            $Body -like '`{*' -and # Make sure the body is an object
            $Body -like "*[System.Id]*" -and
            $Body -like "*[System.Title]*" -and
            $Body -like "*[System.State]*" -and
            $Body -like '*`}' -and # Make sure the body is an object
            $ContentType -eq 'application/json' -and
            $Uri -eq "https://dev.azure.com/test/test/test team/_apis/wit/wiql?api-version=$(_getApiVersion Core)&`$top=100"
         }
      }

      It 'Get work items with custom WIQL query with -Top 250' {
         $wiqlQuery = "Select [System.Id], [System.Title], [System.State] From WorkItems"
         Get-VSTeamWiql -ProjectName "test" -Team "test team" -Query $wiqlQuery -Top 250

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Post' -and
            $Body -like '`{*' -and # Make sure the body is an object
            $Body -like "*[System.Id]*" -and
            $Body -like "*[System.Title]*" -and
            $Body -like "*[System.State]*" -and
            $Body -like '*`}' -and # Make sure the body is an object
            $ContentType -eq 'application/json' -and
            $Uri -eq "https://dev.azure.com/test/test/test team/_apis/wit/wiql?api-version=$(_getApiVersion Core)&`$top=250"
         }
      }

      It 'Get work items with custom WIQL query with -Top 0' {
         $wiqlQuery = "Select [System.Id], [System.Title], [System.State] From WorkItems"
         Get-VSTeamWiql -ProjectName "test" -Team "test team" -Query $wiqlQuery -Top 0

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Post' -and
            $Body -like '`{*' -and # Make sure the body is an object
            $Body -like "*[System.Id]*" -and
            $Body -like "*[System.Title]*" -and
            $Body -like "*[System.State]*" -and
            $Body -like '*`}' -and # Make sure the body is an object
            $ContentType -eq 'application/json' -and
            $Uri -eq "https://dev.azure.com/test/test/test team/_apis/wit/wiql?api-version=$(_getApiVersion Core)"
         }
      }

      It 'Get work items with custom WIQL query with expanded work items' {
         $wiqlQuery = "Select [System.Id], [System.Title], [System.State] From WorkItems"
         Get-VSTeamWiql -ProjectName "test" -Team "test team" -Query $wiqlQuery -Expand

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Post' -and
            $Body -like '`{*' -and # Make sure the body is an object
            $Body -like "*[System.Id]*" -and
            $Body -like "*[System.Title]*" -and
            $Body -like "*[System.State]*" -and
            $Body -like '*`}' -and # Make sure the body is an object
            $ContentType -eq 'application/json' -and
            $Uri -eq "https://dev.azure.com/test/test/test team/_apis/wit/wiql?api-version=$(_getApiVersion Core)&`$top=100"
         }
      }

      It 'Get work items with custom WIQL query with time precision' {
         $wiqlQuery = "Select [System.Id], [System.Title], [System.State] From WorkItems"
         Get-VSTeamWiql -ProjectName "test" -Team "test team" -Query $wiqlQuery -TimePrecision

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Post' -and
            $Body -like '`{*' -and # Make sure the body is an object
            $Body -like "*[System.Id]*" -and
            $Body -like "*[System.Title]*" -and
            $Body -like "*[System.State]*" -and
            $Body -like '*`}' -and # Make sure the body is an object
            $ContentType -eq 'application/json' -and
            $Uri -like "*timePrecision=True*" -and
            $Uri -like "*`$top=100*" -and
            $Uri -like "https://dev.azure.com/test/test/test team/_apis/wit/wiql?api-version=$(_getApiVersion Core)*"
         }
      }

      It 'Get work items with query ID query' {
         Get-VSTeamWiql -ProjectName "test" -Team "test team" -Id 1

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/test/test team/_apis/wit/wiql/1?api-version=$(_getApiVersion Core)&`$top=100"
         }
      }

      It 'Get work items with query ID query with expanded work items' {
         Get-VSTeamWiql -ProjectName "test" -Team "test team" -Id 1 -Expand

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/test/test team/_apis/wit/wiql/1?api-version=$(_getApiVersion Core)&`$top=100"
         }
      }
   }
}