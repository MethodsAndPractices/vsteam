Set-StrictMode -Version Latest

Describe "VSTeamGitRepository" {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      ## Arrange
      Mock Invoke-RestMethod { Open-SampleFile 'Get-VSTeamGitRepository-ProjectNamePeopleTracker-NamePeopleTracker.json' } -ParameterFilter {
         $Uri -like "*00000000-0000-0000-0000-000000000000*" -or
         $Uri -like "*testRepo*"
      }
      
      Mock Invoke-RestMethod { throw [System.Net.WebException] } -ParameterFilter {
         $Uri -like "*00000000-0000-0000-0000-000000000101*" -or
         $Uri -like "*boom*"
      }
   }

   Context 'Remove-VSTeamGitRepository' {
      Context 'Services' {
         BeforeAll {
            ## Arrange
            Mock _getInstance { return 'https://dev.azure.com/test' }
         }

         It 'by id should remove Git repo' {
            ## Act
            Remove-VSTeamGitRepository -id 00000000-0000-0000-0000-000000000000 -Force

            ## Assert
            Should -Invoke Invoke-RestMethod -ParameterFilter {
               $Method -eq 'Delete' -and
               $Uri -eq "https://dev.azure.com/test/_apis/git/repositories/00000000-0000-0000-0000-000000000000?api-version=$(_getApiVersion Git)"
            }
         }

         It 'by Id should throw' {
            { Remove-VSTeamGitRepository -id 00000000-0000-0000-0000-000000000101 -Force } | Should -Throw
         }
      }

      Context 'Server' {
         BeforeAll {
            ## Arrange
            Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' }
         }

         It 'by id should remove Git repo' {
            ## Act
            Remove-VSTeamGitRepository -id 00000000-0000-0000-0000-000000000000 -Force

            ## Assert
            Should -Invoke Invoke-RestMethod -ParameterFilter {
               $Method -eq 'Delete' -and
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/_apis/git/repositories/00000000-0000-0000-0000-000000000000?api-version=$(_getApiVersion Git)"
            }
         }
      }
   }
}