Set-StrictMode -Version Latest

InModuleScope Refs {

   # Set the account to use for testing. A normal user would do this
   # using the Add-VSTeamAccount function.
   [VSTeamVersions]::Account = 'https://test.visualstudio.com'

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

   Describe "Git VSTS" {
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

      Context 'Get-VSTeamGitRef by id throws' {
         Mock Invoke-RestMethod { throw [System.Net.WebException] "Test Exception." }

         It 'Should return a single repo by id' {
            { Get-VSTeamGitRef -ProjectName Test -RepositoryId 00000000-0000-0000-0000-000000000000 } | Should Throw
         }
      }
   }
}