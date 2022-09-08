Set-StrictMode -Version Latest

Describe "VSTeamGitRepository" {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      
      # Without adding this call, an exception is thrown stating that Get-VSTeamGitRepository is a part of VSTeam but the module could not be loaded. Because we're not testing this function, but it is used in the function we are testing I created it here to facilitate the tests. 
      function Get-VSTeamGitRepository {
         param(
            $Name,
            $ProjectName
         )
         $Repo = _callAPI -Method Get -ProjectName $ProjectName `
            -Area "git" `
            -Resource "repositories" `
            -id $Name `
            -Version $(_getApiVersion Git)
         $Repo
      }
      
      Mock Get-VSTeamGitRef { (Open-SampleFile 'Get-VSTeamGitRef_for_Update-VSTeamGitRepositoryDefaultBranch.json').value } -ParameterFilter {
         $ProjectName -like "*Peopletracker*"
      }
      Mock Invoke-RestMethod { Open-SampleFile 'Get-VSTeamGitRepository.json' }
      Mock Invoke-RestMethod { Open-SampleFile 'Get-VSTeamGitRepository-ProjectNamePeopleTracker-NamePeopleTracker.json' } -ParameterFilter {
         $Uri -like "*00000000-0000-0000-0000-000000000000*" -or $URI -like "*Peopletracker*"
      }
      
      Mock Invoke-RestMethod { throw [System.Net.WebException] } -ParameterFilter {
         $Uri -like "*00000000-0000-0000-0000-000000000101*" -or
         $Uri -like "*boom*"
      }
   }

   Context 'Update-VSTeamGitRepositoryDefaultBranch' {
      Context 'Services' {
         BeforeAll {
            ## Arrange
            Mock _getInstance { return 'https://dev.azure.com/Test' }
         }

         It "by name should update Git repo's default branch" {
            ## Act
            Update-VSTeamGitRepositoryDefaultBranch -Name PeopleTracker -projectname PeopleTracker -DefaultBranch 'master'

            ## Assert
            Should -Invoke Invoke-RestMethod -ParameterFilter {
               $Method -eq 'Patch' -and $Uri -eq "https://dev.azure.com/Test/PeopleTracker/_apis/git/repositories/00000000-0000-0000-0000-000000000000?api-version=$(_getApiVersion Git)"
            }
         }

         It 'by id should throw' {
            { Update-VSTeamGitRepositoryDefaultBranch -id 00000000-0000-0000-0000-000000000101  -projectname PeopleTracker -DefaultBranch 'develop' } | Should -Throw
         }
         It 'should throw if the branch does not exist' {
            { Update-VSTeamGitRepositoryDefaultBranch -id 00000000-0000-0000-0000-000000000101  -projectname PeopleTracker -DefaultBranch 'notarealbranch' } | Should -Throw
         }
      }
   }
}