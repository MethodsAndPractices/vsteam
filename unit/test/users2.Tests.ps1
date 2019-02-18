Set-StrictMode -Version Latest

InModuleScope VSTeam {

   # Set the account to use for testing. A normal user would do this
   # using the Set-VSTeamAccount function.
   [VSTeamVersions]::Account = 'https://dev.azure.com/test'

   $userListResult = Get-Content "$PSScriptRoot\sampleFiles\users.json" -Raw | ConvertFrom-Json
   $userSingleResult = Get-Content "$PSScriptRoot\sampleFiles\users.single.json" -Raw | ConvertFrom-Json

   # The Graph API is not supported on TFS
   Describe "Users TFS Errors" {
     Context 'Get-VSTeamUser2' {
         Mock _callAPI { throw 'Should not be called' } -Verifiable

         It 'Should throw' {
            Set-VSTeamAPIVersion TFS2017

            { Get-VSTeamUser2 } | Should Throw
         }
      }
   }

   Describe 'Users VSTS' {
      # You have to set the version or the api-version will not be added when
      # [VSTeamVersions]::Graph = ''
      [VSTeamVersions]::Graph = '5.0'

      Context 'Get-VSTeamUser2 list' {
         Mock Invoke-RestMethod {
            # If this test fails uncomment the line below to see how the mock was called.
            # Write-Host $args

            return $userListResult
         } -Verifiable

         Get-VSTeamUser2

         It 'Should return users' {
            # With PowerShell core the order of the query string is not the
            # same from run to run!  So instead of testing the entire string
            # matches I have to search for the portions I expect but can't
            # assume the order.
            # The general string should look like this:
            # "https://vssps.dev.azure.com/test/_apis/graph/users?api-version=$([VSTeamVersions]::Graph)"
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -like "https://vssps.dev.azure.com/test/_apis/graph/users*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Graph)*"
            }
         }
      }

      Context 'Get-VSTeamUser2 by subjectTypes' {
         Mock Invoke-RestMethod { return $userListResult } -Verifiable

         Get-VSTeamUser2 -SubjectTypes vss,aad

         It 'Should return users' {
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -like "https://vssps.dev.azure.com/test/_apis/graph/users*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Graph)*" -and
               $Uri -like "*subjectTypes=vss,aad*"
            }
         }
      }

      Context 'Get-VSTeamUser2 by descriptor' {
         Mock Invoke-RestMethod { return $userSingleResult } -Verifiable

         Get-VSTeamUser2 -UserDescriptor 'aad.OTcyOTJkNzYtMjc3Yi03OTgxLWIzNDMtNTkzYmM3ODZkYjlj'

         It 'Should return the user' {
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -like "https://vssps.dev.azure.com/test/_apis/graph/users/aad.OTcyOTJkNzYtMjc3Yi03OTgxLWIzNDMtNTkzYmM3ODZkYjlj*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Graph)*"
            }
         }
      }

      Context 'Get-VSTeamUser2 list throws' {
         Mock Invoke-RestMethod { throw 'Error' }

         It 'Should throw' {
            { Get-VSTeamUser2 } | Should Throw
         }
      }

      Context 'Get-VSTeamUser2 by descriptor throws' {
         Mock Invoke-RestMethod { throw 'Error' }

         It 'Should throw' {
            { Get-VSTeamUser2 -UserDescriptor  } | Should Throw
         }
      }
   }
}