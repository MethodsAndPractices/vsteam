Set-StrictMode -Version Latest

$env:Testing=$true
InModuleScope VSTeam {
   Describe "Git VSTS" {
      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable

      $results = [PSCustomObject]@{
         value = [PSCustomObject]@{
            objectId = '6f365a7143e492e911c341451a734401bcacadfd'
            name     = 'refs/heads/master'
            creator  = [PSCustomObject]@{
               displayName = 'Microsoft.VisualStudio.Services.TFS'
               id          = '1'
               uniqueName  = 'some@email.com'
            }
         }
      }
   
      # Mock the call to Get-Projects by the dynamic parameter for ProjectName
      Mock Invoke-RestMethod { return @() } -ParameterFilter {
         $Uri -like "*_apis/projects*"
      }

      . "$PSScriptRoot\mocks\mockProjectNameDynamicParam.ps1"

      Context 'Get-VSTeamGitRef' {
         Mock Invoke-RestMethod { return $results } -Verifiable

         Get-VSTeamGitRef -ProjectName Test -RepositoryId 00000000-0000-0000-0000-000000000000

         It 'Should return a single ref by id' {
            Assert-VerifiableMock
         }
      }

      Context 'Get-VSTeamGitRef with Filter' {
         Mock Invoke-RestMethod { return $results } -Verifiable -ParameterFilter {
            $Uri -like "*filter=refs*"
         }

         Get-VSTeamGitRef -ProjectName Test -RepositoryId 00000000-0000-0000-0000-000000000000 -Filter "refs/heads"

         It 'Should return a single ref with filter' {
            Assert-VerifiableMock
         }
      }

      Context 'Get-VSTeamGitRef with FilterContains' {
         Mock Invoke-RestMethod { return $results } -Verifiable -ParameterFilter {
            $Uri -like "*filterContains=test"
         }

         Get-VSTeamGitRef -ProjectName Test -RepositoryId 00000000-0000-0000-0000-000000000000 -FilterContains "test"

         It 'Should return a single ref' {
            Assert-VerifiableMock
         }
      }

      Context 'Get-VSTeamGitRef with Top' {
         Mock Invoke-RestMethod { return $results } -Verifiable -ParameterFilter {
            $Uri -like "*`$top=100"
         }

         Get-VSTeamGitRef -ProjectName Test -RepositoryId 00000000-0000-0000-0000-000000000000 -Top 100

         It 'Should return a single ref' {
            Assert-VerifiableMock
         }
      }

      Context 'Get-VSTeamGitRef with ContinuationToken' {
         Mock Invoke-RestMethod { return $results } -Verifiable -ParameterFilter {
            $Uri -like "*continuationToken=myToken"
         }

         Get-VSTeamGitRef -ProjectName Test -RepositoryId 00000000-0000-0000-0000-000000000000 -ContinuationToken "myToken"

         It 'Should return a single ref' {
            Assert-VerifiableMock
         }
      }

      Context 'Get-VSTeamGitRef with Filter, FilterContains, Top' {
         Mock Invoke-RestMethod { return $results } -Verifiable -ParameterFilter {
            $Uri -like "*filter=/refs/heads*" -and
            $Uri -like "*`$top=500*" -and
            $Uri -like "*filterContains=test*"
         }

         Get-VSTeamGitRef -ProjectName Test -RepositoryId 00000000-0000-0000-0000-000000000000 -Filter "/refs/heads" -FilterContains "test" -Top 500

         It 'Should return a single ref' {
            Assert-VerifiableMock
         }
      }

      Context 'Get-VSTeamGitRef by id throws' {
         Mock Invoke-RestMethod { throw [System.Net.WebException] "Test Exception." }

         It 'Should return a single repo by id' {
            { Get-VSTeamGitRef -ProjectName Test -RepositoryId 00000000-0000-0000-0000-000000000000 } | Should Throw
         }
      }
   }
}