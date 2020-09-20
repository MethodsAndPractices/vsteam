Set-StrictMode -Version Latest

Describe "VSTeamUserEntitlement" -Tag 'VSTeamUserEntitlement' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      . "$baseFolder/Source/Public/Get-VSTeamUserEntitlement.ps1"
   }

   Context 'Update-VSTeamUserEntitlement' {
      BeforeAll {
         Mock _getApiVersion { return 'VSTS' }
         Mock _getInstance { return 'https://dev.azure.com/test' }
         Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'MemberEntitlementManagement' }

         # Update Call
         Mock _callAPI -ParameterFilter { $Method -eq 'Patch' }

         # Get-VSTeamUserEntitlement by email
         Mock _callAPI { Open-SampleFile 'Get-VSTeamUserEntitlement.json' }

         # Get-VSTeamUserEntitlement by id
         Mock _callAPI { Open-SampleFile 'Get-VSTeamUserEntitlement-Id.json' } -ParameterFilter {
            $id -eq '00000000-0000-0000-0000-000000000000'
         }
      }

      It 'by email should update a user' {
         Update-VSTeamUserEntitlement -License 'Stakeholder' `
            -LicensingSource msdn `
            -MSDNLicenseType enterprise `
            -Email 'dlbm3@test.com' `
            -Force

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
         { Update-VSTeamUserEntitlement -Id '11111111-0000-0000-0000-000000000000' -License 'Express' -Force } | Should -Throw
      }
   }
}