Set-StrictMode -Version Latest

Describe 'VSTeamUser' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
   }
   
   Context "Get-VSTeamUser" {
      Context "Server" {
         BeforeAll {
            Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' }
         }

         Context 'Get-VSTeamUser' {
            BeforeAll {
               Mock _getApiVersion { return 'TFS2017' }
               Mock _callAPI { throw 'Should not be called' }
               Mock _getApiVersion { return '' } -ParameterFilter { $Service -eq 'Graph' }
            }

            It 'Should throw' {
               { Get-VSTeamUser } | Should -Throw
            }
         }
      }

      Context 'Services' {
         BeforeAll {
            # Set the account to use for testing. A normal user would do this
            # using the Set-VSTeamAccount function.
            Mock _getInstance { return 'https://dev.azure.com/test' }

            # You have to set the version or the api-version will not be added when [vsteam_lib.Versions]::Graph = ''
            Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Graph' }
         }

         Context 'Get-VSTeamUser' {
            BeforeAll {
               Mock Invoke-RestMethod { Open-SampleFile 'users.json' }
            }
            
            It 'Should list users' {
               Get-VSTeamUser

               # With PowerShell core the order of the query string is not the
               # same from run to run!  So instead of testing the entire string
               # matches I have to search for the portions I expect but can't
               # assume the order.
               # The general string should look like this:
               # "https://vssps.dev.azure.com/test/_apis/graph/users?api-version=$(_getApiVersion Graph)"
               Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope Context -ParameterFilter {
                  $Uri -like "https://vssps.dev.azure.com/test/_apis/graph/users*" -and
                  $Uri -like "*api-version=$(_getApiVersion Graph)*"
               }
            }
            
            It 'Should return users by subjectTypes' {
               Get-VSTeamUser -SubjectTypes vss, aad

               Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope Context -ParameterFilter {
                  $Uri -like "https://vssps.dev.azure.com/test/_apis/graph/users*" -and
                  $Uri -like "*api-version=$(_getApiVersion Graph)*" -and
                  $Uri -like "*subjectTypes=vss,aad*"
               }
            }
         }

         Context 'Get-VSTeamUser by descriptor' {
            BeforeAll {
               Mock Invoke-RestMethod { Open-SampleFile 'users.single.json' }
            }

            It 'Should return the user' {
               Get-VSTeamUser -UserDescriptor 'aad.OTcyOTJkNzYtMjc3Yi03OTgxLWIzNDMtNTkzYmM3ODZkYjlj'

               Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
                  $Uri -like "https://vssps.dev.azure.com/test/_apis/graph/users/aad.OTcyOTJkNzYtMjc3Yi03OTgxLWIzNDMtNTkzYmM3ODZkYjlj*" -and
                  $Uri -like "*api-version=$(_getApiVersion Graph)*"
               }
            }
         }

         Context 'Get-VSTeamUser list throws' {
            BeforeAll {
               Mock Invoke-RestMethod { throw 'Error' }
            }

            It 'Should throw' {
               { Get-VSTeamUser } | Should -Throw
            }
         }

         Context 'Get-VSTeamUser by descriptor throws' {
            BeforeAll {
               Mock Invoke-RestMethod { throw 'Error' }
            }

            It 'Should throw' {
               { Get-VSTeamUser -UserDescriptor } | Should -Throw
            }
         }
      }
   }
}