Set-StrictMode -Version Latest

Describe "VSTeamUserEntitlement" -Tag 'VSTeamUserEntitlement' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
   }

   Context "Get-VSTeamUserEntitlement" {
      Context "Server" {
         BeforeAll {
            Mock _getApiVersion { return 'AzD2019' }
            Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' }
            Mock _getApiVersion { return '' } -ParameterFilter { $Service -eq 'MemberEntitlementManagement' }
         }

         Context 'Get-VSTeamUserEntitlement' {
            BeforeAll {
               Mock _callAPI { throw 'Should not be called' }
            }

            It 'not supported should throw' {
               { Get-VSTeamUserEntitlement } | Should -Throw
            }

            It '_callAPI should not be called' {
               Should -Invoke _callAPI -Exactly -Times 0 -Scope Context
            }
         }
      }

      Context "Services" {
         BeforeAll {
            Mock _getApiVersion { return 'VSTS' }
            Mock _getInstance { return 'https://dev.azure.com/test' }
            

            Mock Invoke-RestMethod { Open-SampleFile 'Get-VSTeamUserEntitlement.json' }
            Mock Invoke-RestMethod { Open-SampleFile 'Get-VSTeamUserEntitlement-Id.json' } -ParameterFilter {
               $Uri -like "*00000000-0000-0000-0000-000000000000*"
            }
         }

         Context 'Get-VSTeamUserEntitlement up to version 6.0' {
            BeforeAll {
               Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'MemberEntitlementManagement' }
            }

            It 'no parameters should return users' {
               $users = Get-VSTeamUserEntitlement
   
               $users.count | Should -Be 3
               $users[0].UserName | Should -Be 'Math lastName'
   
               # Make sure it was called with the correct URI
               Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
                  $Uri -eq "https://vsaex.dev.azure.com/test/_apis/userentitlements?api-version=$(_getApiVersion MemberEntitlementManagement)&top=100&skip=0"
               }
            }
   
            It 'by Id should return users with projects' {
               $user = Get-VSTeamUserEntitlement -Id '00000000-0000-0000-0000-000000000000'
   
               $user.Email | Should -Be 'test@test.com' -Because 'email is from type'
               $user.userName | Should -Be 'Donovan Brown' -Because 'userName is from type'
   
               Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
                  $Uri -eq "https://vsaex.dev.azure.com/test/_apis/userentitlements/00000000-0000-0000-0000-000000000000?api-version=$(_getApiVersion MemberEntitlementManagement)"
               }
            }

            It 'with select for projects should return users with projects' {
               Get-VSTeamUserEntitlement -Select Projects
   
               Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
                  $Uri -eq "https://vsaex.dev.azure.com/test/_apis/userentitlements?api-version=$(_getApiVersion MemberEntitlementManagement)&top=100&skip=0&select=Projects"
               }
            }

            It 'should throw with paged parameterset and version below 6.0 ' {
               { Get-VSTeamUserEntitlement -Name 'Math' } | Should -Throw
            }

         }

         Context 'Get-VSTeamUserEntitlement version 6.0 onwards' {
            BeforeAll {
               Mock _getApiVersion { return '6.0-unitTests' } -ParameterFilter { $Service -eq 'MemberEntitlementManagement' }
               Mock Invoke-RestMethod { Open-SampleFile 'Get-VSTeamUserEntitlement-ContinuationToken.json' } -ParameterFilter {
                  $Uri -match "filter=userType eq 'guest'$"
               }
               Mock Invoke-RestMethod { Open-SampleFile 'Get-VSTeamUserEntitlement.json' } -ParameterFilter {
                  $Uri -like "*filter=userType eq 'guest'&continuationToken=*"
               }
            }

            It 'should throw by ID and version 6.0 onwards' {
               { Get-VSTeamUserEntitlement -Id '00000000-0000-0000-0000-000000000000' } | Should -Throw
            }
            
            It "with incorrect case in license parameter should throw" {
               { Get-VSTeamUserEntitlement -License account-Advanced} | Should -Throw
            }

            It "with incorrect case in usertype parameter should throw" {
               { Get-VSTeamUserEntitlement -UserType Member} | Should -Throw
            }

            It 'no parameters should return users' {
               $users = Get-VSTeamUserEntitlement
   
               $users.count | Should -Be 3
               $users[0].UserName | Should -Be 'Math lastName'
   
               # Make sure it was called with the correct URI
               Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
                  $Uri -eq "https://vsaex.dev.azure.com/test/_apis/userentitlements?api-version=$(_getApiVersion MemberEntitlementManagement)"
               }
            }

            It 'by filter should return users that match that filter' {
               Get-VSTeamUserEntitlement -Filter "name eq 'Math'"

               # Make sure it was called with the correct URI parameters
               Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
                  $Uri -eq "https://vsaex.dev.azure.com/test/_apis/userentitlements?api-version=$(_getApiVersion MemberEntitlementManagement)&`$filter=name eq 'Math'"
               }
            }

            It 'by name should translate to filter' {
               Get-VSTeamUserEntitlement -Name "Math" -License Account-Advanced -UserType member

               # Make sure it was called with the correct URI parameters. Filter parameter names are case sensitive
               Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
                  $Uri -eq "https://vsaex.dev.azure.com/test/_apis/userentitlements?api-version=$(_getApiVersion MemberEntitlementManagement)&`$filter=name eq 'Math' and licenseId eq 'Account-Advanced' and userType eq 'member'"
               }
            }

            It 'with many matches continuationToken is used' {
               $users = Get-VSTeamUserEntitlement -UserType guest
               $users.Count | Should -Be 6

               Should -Invoke Invoke-RestMethod -Exactly -Times 2
            }
   
         }
      }
   }
}