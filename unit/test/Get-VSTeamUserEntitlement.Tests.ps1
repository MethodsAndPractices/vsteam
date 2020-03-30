Set-StrictMode -Version Latest

#region include
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Private/applyTypes.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/$sut"
#endregion

Describe "VSTeamUserEntitlement" {
   Context "Get-VSTeamUserEntitlement" {
      Mock Invoke-RestMethod { return @() } -ParameterFilter { $Uri -like "*_apis/projects*" }

      Context "Server" {
         Mock _getApiVersion { return 'TFS2017' }
         Mock _getApiVersion { return '' } -ParameterFilter { $Service -eq 'MemberEntitlementManagement' }
         Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' }

         Context 'Get-VSTeamUserEntitlement' {
            Mock _callAPI { throw 'Should not be called' }

            It 'not supported should throw' {
               { Get-VSTeamUserEntitlement } | Should Throw
            }

            It '_callAPI should not be called' {
               Assert-MockCalled _callAPI -Exactly -Times 0 -Scope Context
            }
         }
      }

      Context "Services" {
         Mock _getApiVersion { return 'VSTS' }
         Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'MemberEntitlementManagement' }
         Mock _getInstance { return 'https://dev.azure.com/test' }

         . "$PSScriptRoot\mocks\mockProjectDynamicParamMandatoryFalse.ps1"

         Context 'Get-VSTeamUserEntitlement' {
            Mock Invoke-RestMethod { return [PSCustomObject]@{ members = [PSCustomObject]@{ accessLevel = [PSCustomObject]@{ } } } }
            Mock Invoke-RestMethod { return [PSCustomObject]@{ accessLevel = [PSCustomObject]@{ }; email = 'fake@email.com' } } -ParameterFilter {
               $Uri -like "*00000000-0000-0000-0000-000000000000*"
            }
            Mock Invoke-RestMethod { return [PSCustomObject]@{ members = [PSCustomObject]@{ accessLevel = [PSCustomObject]@{ }; email = 'fake@email.com' } } } -ParameterFilter {
               $Uri -like "*select=Projects*"
            }

            It 'no parameters should return users' {
               Get-VSTeamUserEntitlement

               # Make sure it was called with the correct URI
               Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
                  $Uri -eq "https://vsaex.dev.azure.com/test/_apis/userentitlements?api-version=$(_getApiVersion MemberEntitlementManagement)&top=100&skip=0"
               }
            }            

            It 'by Id should return users with projects' {
               Get-VSTeamUserEntitlement -Id '00000000-0000-0000-0000-000000000000'

               Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
                  $Uri -eq "https://vsaex.dev.azure.com/test/_apis/userentitlements/00000000-0000-0000-0000-000000000000?api-version=$(_getApiVersion MemberEntitlementManagement)"
               }
            }

            It 'with select for projects should return users with projects' {
               Get-VSTeamUserEntitlement -Select Projects

               Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
                  $Uri -eq "https://vsaex.dev.azure.com/test/_apis/userentitlements?api-version=$(_getApiVersion MemberEntitlementManagement)&top=100&skip=0&select=Projects"
               }
            }
         }
      }
   }
}