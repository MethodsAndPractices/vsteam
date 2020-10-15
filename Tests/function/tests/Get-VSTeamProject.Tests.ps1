Set-StrictMode -Version Latest

Describe 'VSTeamProject' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Core' }
   }

   Context 'Get-VSTeamProject' {
      BeforeAll {
         $env:TEAM_TOKEN = '1234'

         Mock Invoke-RestMethod { Open-SampleFile 'Get-VSTeamProject.json' }
         Mock Invoke-RestMethod { Open-SampleFile 'Get-VSTeamProject-NamePeopleTracker.json' } -ParameterFilter {
            $Uri -like "*PeopleTracker*"
         }
      }

      AfterAll {
         $env:TEAM_TOKEN = $null
      }

      It 'with no parameters using BearerToken should return projects' {
         Get-VSTeamProject

         # Make sure it was called with the correct URI
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "*https://dev.azure.com/test/_apis/projects*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Uri -like "*stateFilter=WellFormed*"
         }
      }

      It 'with top 10 should return top 10 projects' {
         Get-VSTeamProject -top 10

         # Make sure it was called with the correct URI
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "*https://dev.azure.com/test/_apis/projects*" -and
            $Uri -like "*`$top=10*" -and
            $Uri -like "*stateFilter=WellFormed*"
         }
      }

      It 'with skip 1 should skip first project' {
         Get-VSTeamProject -skip 1

         # Make sure it was called with the correct URI
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "*https://dev.azure.com/test/_apis/projects*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Uri -like "*`$skip=1*" -and
            $Uri -like "*stateFilter=WellFormed*"
         }
      }

      It 'with stateFilter All should return All projects' {
         Get-VSTeamProject -stateFilter 'All'

         # Make sure it was called with the correct URI
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "*https://dev.azure.com/test/_apis/projects*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Uri -like "*stateFilter=All*"
         }
      }

      It 'with no Capabilities by name should return the project' {
         Get-VSTeamProject -Name PeopleTracker

         # Make sure it was called with the correct URI
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/_apis/projects/PeopleTracker?api-version=$(_getApiVersion Core)"
         }
      }

      It 'with Capabilities by name should return the project with capabilities' {
         Get-VSTeamProject -projectId PeopleTracker -includeCapabilities

         # Make sure it was called with the correct URI
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "*https://dev.azure.com/test/_apis/projects/PeopleTracker*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Uri -like "*includeCapabilities=True*"
         }
      }
   }
}