Set-StrictMode -Version Latest

Describe "VSTeamUserEntitlement" -Tag 'VSTeamUserEntitlement' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      . "$baseFolder/Source/Public/Get-VSTeamUserEntitlement.ps1"
   }

   Context "Remove-VSTeamUserEntitlement" {
      BeforeAll {
         Mock _getApiVersion { return 'VSTS' }
         Mock _getInstance { return 'https://dev.azure.com/test' }
         Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'MemberEntitlementManagement' }
      }

      Context 'Remove-VSTeamUserEntitlement' {
         BeforeAll {
            # Get-VSTeamUserEntitlement by Id
            Mock _callAPI { Open-SampleFile 'Get-VSTeamUserEntitlement-Id.json' } -ParameterFilter {
               $Id -eq '00000000-0000-0000-0000-000000000000'
            }

            # Get-VSTeamUserEntitlement by email
            Mock _callAPI { Open-SampleFile 'Get-VSTeamUserEntitlement.json' }

            # Remove Call
            Mock _callAPI -ParameterFilter { $Method -eq 'Delete' }
         }

         It 'by Id should remove user' {
            Remove-VSTeamUserEntitlement -UserId '00000000-0000-0000-0000-000000000000' -Force
            Should -Invoke _callAPI -Exactly -Times 1 -Scope It -ParameterFilter {
               $subDomain -eq 'vsaex' -and
               $id -eq '00000000-0000-0000-0000-000000000000' -and
               $resource -eq 'userentitlements' -and
               $method -eq 'Delete' -and
               $version -eq $(_getApiVersion MemberEntitlementManagement)
            }
         }

         It 'bye email should remove user' {
            Remove-VSTeamUserEntitlement -Email 'dlbm3@test.com' -Force

            Should -Invoke _callAPI -Exactly -Times 1 -Scope It -ParameterFilter {
               $Method -eq 'Delete' -and
               $subDomain -eq 'vsaex' -and
               $id -eq '00000000-0000-0000-0000-000000000000' -and
               $resource -eq 'userentitlements' -and
               $version -eq $(_getApiVersion MemberEntitlementManagement)
            }
         }

         It 'by invalid email should throw' {
            { Remove-VSTeamUserEntitlement -Email 'not@found.com' -Force } | Should -Throw
         }
      }
   }
}