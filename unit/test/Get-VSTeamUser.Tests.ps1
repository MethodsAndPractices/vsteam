Set-StrictMode -Version Latest

#region include
Import-Module SHiPS

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamLeaf.ps1"
. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamUser.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Classes/ProjectValidateAttribute.ps1"
. "$here/../../Source/Private/applyTypes.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/Set-VSTeamAPIVersion.ps1"
. "$here/../../Source/Public/$sut"
#endregion

Describe 'VSTeamUser' {
   Context "Get-VSTeamUser" {
      $userListResult = Get-Content "$PSScriptRoot\sampleFiles\users.json" -Raw | ConvertFrom-Json
      $userSingleResult = Get-Content "$PSScriptRoot\sampleFiles\users.single.json" -Raw | ConvertFrom-Json

      # The Graph API is not supported on TFS
      Context "Server" {
         Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' }
      
         Context 'Get-VSTeamUser' {
            Mock _callAPI { throw 'Should not be called' }
            Mock _getApiVersion { return 'TFS2017' }
            Mock _getApiVersion { return '' } -ParameterFilter { $Service -eq 'Graph' }

            It 'Should throw' {
               { Get-VSTeamUser } | Should Throw
            }
         }
      }

      Context 'Services' {
         # Set the account to use for testing. A normal user would do this
         # using the Set-VSTeamAccount function.
         Mock _getInstance { return 'https://dev.azure.com/test' }

         # You have to set the version or the api-version will not be added when [VSTeamVersions]::Graph = ''
         Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Graph' }

         Context 'Get-VSTeamUser list' {
            Mock Invoke-RestMethod {
               # If this test fails uncomment the line below to see how the mock was called.
               # Write-Host $args

               return $userListResult
            }

            Get-VSTeamUser

            It 'Should return users' {
               # With PowerShell core the order of the query string is not the
               # same from run to run!  So instead of testing the entire string
               # matches I have to search for the portions I expect but can't
               # assume the order.
               # The general string should look like this:
               # "https://vssps.dev.azure.com/test/_apis/graph/users?api-version=$(_getApiVersion Graph)"
               Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
                  $Uri -like "https://vssps.dev.azure.com/test/_apis/graph/users*" -and
                  $Uri -like "*api-version=$(_getApiVersion Graph)*"
               }
            }
         }

         Context 'Get-VSTeamUser by subjectTypes' {
            Mock Invoke-RestMethod { return $userListResult } -Verifiable

            Get-VSTeamUser -SubjectTypes vss, aad

            It 'Should return users' {
               Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
                  $Uri -like "https://vssps.dev.azure.com/test/_apis/graph/users*" -and
                  $Uri -like "*api-version=$(_getApiVersion Graph)*" -and
                  $Uri -like "*subjectTypes=vss,aad*"
               }
            }
         }

         Context 'Get-VSTeamUser by descriptor' {
            Mock Invoke-RestMethod { 
               # If this test fails uncomment the line below to see how the mock was called.
               # Write-Host $args
               return $userSingleResult 
            }

            It 'Should return the user' {
               Get-VSTeamUser -UserDescriptor 'aad.OTcyOTJkNzYtMjc3Yi03OTgxLWIzNDMtNTkzYmM3ODZkYjlj'

               Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
                  $Uri -like "https://vssps.dev.azure.com/test/_apis/graph/users/aad.OTcyOTJkNzYtMjc3Yi03OTgxLWIzNDMtNTkzYmM3ODZkYjlj*" -and
                  $Uri -like "*api-version=$(_getApiVersion Graph)*"
               }
            }
         }

         Context 'Get-VSTeamUser list throws' {
            Mock Invoke-RestMethod { throw 'Error' }

            It 'Should throw' {
               { Get-VSTeamUser } | Should Throw
            }
         }

         Context 'Get-VSTeamUser by descriptor throws' {
            Mock Invoke-RestMethod { throw 'Error' }

            It 'Should throw' {
               { Get-VSTeamUser -UserDescriptor } | Should Throw
            }
         }
      }
   }
}