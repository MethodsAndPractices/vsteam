Set-StrictMode -Version Latest

Describe "VSTeamUserEntitlement" {
   BeforeAll {
      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProjectCache.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectValidateAttribute.ps1"
      . "$PSScriptRoot/../../Source/Private/applyTypes.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"
   }

   Context "Get-VSTeamUserEntitlement" {
      BeforeAll {
         Mock Invoke-RestMethod { return @() } -ParameterFilter { $Uri -like "*_apis/projects*" }
      }

      Context "Server" {
         BeforeAll {
            Mock _getApiVersion { return 'TFS2017' }
            Mock _getApiVersion { return '' } -ParameterFilter { $Service -eq 'MemberEntitlementManagement' }
            Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' }
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
            Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'MemberEntitlementManagement' }
            Mock _getInstance { return 'https://dev.azure.com/test' }
         }

         Context 'Get-VSTeamUserEntitlement' {
            BeforeAll {
               Mock Invoke-RestMethod { return [PSCustomObject]@{ members = [PSCustomObject]@{ accessLevel = [PSCustomObject]@{ } } } }
               Mock Invoke-RestMethod { return [PSCustomObject]@{ accessLevel = [PSCustomObject]@{ }; email = 'fake@email.com' } } -ParameterFilter {
                  $Uri -like "*00000000-0000-0000-0000-000000000000*"
               }
               Mock Invoke-RestMethod { return [PSCustomObject]@{ members = [PSCustomObject]@{ accessLevel = [PSCustomObject]@{ }; email = 'fake@email.com' } } } -ParameterFilter {
                  $Uri -like "*select=Projects*"
               }
            }

            It 'no parameters should return users' {
               Get-VSTeamUserEntitlement

               # Make sure it was called with the correct URI
               Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
                  $Uri -eq "https://vsaex.dev.azure.com/test/_apis/userentitlements?api-version=$(_getApiVersion MemberEntitlementManagement)&top=100&skip=0"
               }
            }

            It 'by Id should return users with projects' {
               Get-VSTeamUserEntitlement -Id '00000000-0000-0000-0000-000000000000'

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
         }
      }
   }
}