Set-StrictMode -Version Latest

Describe "VSTeamGitRef" {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      ## Arrange      
      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock Invoke-RestMethod { Open-SampleFile 'Get-VSTeamGitRef.json' }
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Git' }
      Mock Invoke-RestMethod { throw [System.Net.WebException] "Test Exception." } -ParameterFilter {
         $Uri -like "*00000000-0000-0000-0000-000000000001*"
      } 
   }

   Context 'Get-VSTeamGitRef' {
      It 'Should return a single ref by id' {
         ## Act
         Get-VSTeamGitRef -ProjectName Test -RepositoryId 00000000-0000-0000-0000-000000000000
         
         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/Test/_apis/git/repositories/00000000-0000-0000-0000-000000000000/refs?api-version=$(_getApiVersion Git)"
         }
      }

      It 'with Filter should return a single ref with filter' {
         ## Act
         Get-VSTeamGitRef -ProjectName Test -RepositoryId 00000000-0000-0000-0000-000000000000 -Filter "refs/heads"
         
         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "*filter=refs*"
         }
      }

      It 'with FilterContains should return a single ref' {
         ## Act
         Get-VSTeamGitRef -ProjectName Test -RepositoryId 00000000-0000-0000-0000-000000000000 -FilterContains "test"
         
         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "*filterContains=test"
         }
      }

      It 'Should return a single ref' {
         ## Act
         Get-VSTeamGitRef -ProjectName Test -RepositoryId 00000000-0000-0000-0000-000000000000 -Top 100
         
         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "*`$top=100"
         }
      }
      
      It 'with ContinuationToken should return a single ref' {
         ## Act
         Get-VSTeamGitRef -ProjectName Test -RepositoryId 00000000-0000-0000-0000-000000000000 -ContinuationToken "myToken"
         
         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "*continuationToken=myToken"
         }
      }

      It 'with Filter, FilterContains, Top should return a single ref' {
         ## Act
         Get-VSTeamGitRef -ProjectName Test -RepositoryId 00000000-0000-0000-0000-000000000000 -Filter "/refs/heads" -FilterContains "test" -Top 500
         
         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "*filter=/refs/heads*" -and
            $Uri -like "*`$top=500*" -and
            $Uri -like "*filterContains=test*"
         }
      }

      It 'by id throws should return a single repo by id' {
         ## Act / Assert
         { Get-VSTeamGitRef -ProjectName Test -RepositoryId 00000000-0000-0000-0000-000000000001 } | Should -Throw
      }
   }
}