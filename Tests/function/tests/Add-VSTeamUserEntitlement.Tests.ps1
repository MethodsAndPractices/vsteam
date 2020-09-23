Set-StrictMode -Version Latest

Describe "VSTeamUserEntitlement" {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
   }

   Context 'Add-VSTeamUserEntitlement' {
      BeforeAll {
         [vsteam_lib.Versions]::ModuleVersion = '0.0.0'

         Mock _callAPI
         Mock _getApiVersion { return 'VSTS' }
         Mock _getInstance { return 'https://dev.azure.com/test' }
      }

      It 'Should add a user' {
         Add-VSTeamUserEntitlement -License earlyAdopter `
            -LicensingSource msdn `
            -MSDNLicenseType enterprise `
            -Email 'test@user.com'

         Should -Invoke _callAPI -ParameterFilter {
            $Method -eq 'Post' -and
            $SubDomain -eq 'vsaex' -and
            $Body -like '*"principalName":*"test@user.com"*' -and
            $Body -like '*"subjectKind":*"user"*'
         }
      }
   }
}