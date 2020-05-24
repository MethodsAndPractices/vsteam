Set-StrictMode -Version Latest

Describe "VSTeamUserEntitlement" {
   BeforeAll {
      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProjectCache.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectCompleter.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectValidateAttribute.ps1"
      . "$PSScriptRoot/../../Source/Private/applyTypes.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamUserEntitlement.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"
   }

   Context 'Update-VSTeamUserEntitlement' {
      BeforeAll {
         Mock _getApiVersion { return 'VSTS' }
         # This will cause the call the _getProject to be skipped
         Mock _hasProjectCacheExpired { return $false }
         Mock _getInstance { return 'https://dev.azure.com/test' }
         Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'MemberEntitlementManagement' }

         # Update Call
         Mock _callAPI -ParameterFilter { $Method -eq 'Patch' }

         # Get-VSTeamUserEntitlement by email
         Mock _callAPI {
            return [PSCustomObject]@{
               members = [PSCustomObject]@{
                  accessLevel = [PSCustomObject]@{
                     accountLicenseType = "Stakeholder"
                     licensingSource    = "msdn"
                     msdnLicenseType    = "enterprise"
                  }
                  email       = 'test@user.com'
                  userName    = 'Test User'
                  id          = '00000000-0000-0000-0000-000000000000'
               }
            }
         }

         # Get-VSTeamUserEntitlement by id
         Mock _callAPI {
            return [PSCustomObject]@{
               accessLevel = [PSCustomObject]@{
                  accountLicenseType = "Stakeholder"
                  licensingSource    = "msdn"
                  msdnLicenseType    = "enterprise"
               }
               email       = 'test@user.com'
               userName    = 'Test User'
               id          = '00000000-0000-0000-0000-000000000000'
            }
         } -ParameterFilter { $id -eq '00000000-0000-0000-0000-000000000000' }
      }

      It 'by email should update a user' {
         Update-VSTeamUserEntitlement -License 'Stakeholder' -LicensingSource msdn -MSDNLicenseType enterprise -Email 'test@user.com' -Force

         Should -Invoke _callAPI -Exactly -Times 1 -Scope It -ParameterFilter {
            $Method -eq 'Patch' -and
            $subDomain -eq 'vsaex' -and
            $id -eq '00000000-0000-0000-0000-000000000000' -and
            $resource -eq 'userentitlements' -and
            $version -eq $(_getApiVersion MemberEntitlementManagement)
         }
      }

      It 'by id should update a user' {
         Update-VSTeamUserEntitlement -Id '00000000-0000-0000-0000-000000000000' -Force

         Should -Invoke _callAPI -Exactly -Times 1 -Scope It -ParameterFilter {
            $Method -eq 'Patch' -and
            $subDomain -eq 'vsaex' -and
            $id -eq '00000000-0000-0000-0000-000000000000' -and
            $resource -eq 'userentitlements' -and
            $version -eq $(_getApiVersion MemberEntitlementManagement)
         }
      }

      It 'with wrong email should update user with invalid email should throw' {
         { Update-VSTeamUserEntitlement -Email 'not@found.com' -License 'Express' -Force } | Should -Throw
      }

      It 'with invalid id should update user with invalid id should throw' {
         { Update-VSTeamUserEntitlement -Id '11111111-0000-0000-0000-000000000000'  -License 'Express' -Force } | Should -Throw
      }
   }
}