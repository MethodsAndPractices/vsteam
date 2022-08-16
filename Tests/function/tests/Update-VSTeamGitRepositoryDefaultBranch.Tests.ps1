Set-StrictMode -Version Latest

Describe "VSTeamGitRepository" {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      . "$PSScriptRoot\..\..\..\Source\Private\common.ps1"

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
            Update-VSTeamGitRepositoryDefaultBranch -Name PeopleTracker -projectname PeopleTracker -DefaultBranch 'develop'

            ## Assert
            Should -Invoke Invoke-RestMethod -ParameterFilter {
               Write-Debug "Method : $Method"
               Write-Debug "Uri : $Uri"
               $Method -eq 'Patch' -and $Uri -eq "https://dev.azure.com/Test/PeopleTracker/_apis/git/repositories/00000000-0000-0000-0000-000000000000?api-version=$(_getApiVersion Git)"
            }
         }

         It 'by id should throw' {
            { Update-VSTeamGitRepositoryDefaultBranch -id 00000000-0000-0000-0000-000000000101  -projectname PeopleTracker -DefaultBranch 'develop' } | Should -Throw
         }
      }

      # Context 'Server' {
      #    BeforeAll {
      #       ## Arrange
      #       Mock _getInstance { return 'https://localhost:8080/tfs' }
      #    }

      #    It "by name should update Git repo's default branch" {
      #       ## Act
      #       Update-VSTeamGitRepositoryDefaultBranch -Name PeopleTracker -projectname PeopleTracker -DefaultBranch 'develop'

      #       ## Assert
      #       Should -Invoke Invoke-RestMethod -ParameterFilter {
      #          Write-Debug "Method : $Method"
      #          Write-Debug "Uri : $Uri"
      #          $Method -eq 'Patch' -and $Uri -eq "https://localhost:8080/tfs/PeopleTracker/PeopleTracker/_apis/git/repositories/00000000-0000-0000-0000-000000000000?api-version=$(_getApiVersion Git)"
      #       }
      #    }
      # }
   }
}