Set-StrictMode -Version Latest

Describe "VSTeamUserEntitlement" {
   BeforeAll {
      Add-Type -Path "$PSScriptRoot/../../dist/bin/vsteam-lib.dll"
      
      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Private/applyTypes.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamUserEntitlement.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"
   }

   Context 'Add-VSTeamUserEntitlement' {
      BeforeAll {
         [VSTeamVersions]::ModuleVersion = '0.0.0'
         Mock _getApiVersion { return 'VSTS' }
         Mock _getInstance { return 'https://dev.azure.com/test' }

         Mock _callAPI
      }

      It 'Should add a user' {
         Add-VSTeamUserEntitlement -License earlyAdopter -LicensingSource msdn -MSDNLicenseType enterprise -Email 'test@user.com'

         Should -Invoke _callAPI -ParameterFilter {
            $Method -eq 'Post' -and
            $SubDomain -eq 'vsaex' -and
            $Body -like '*"principalName":*"test@user.com"*' -and
            $Body -like '*"subjectKind":*"user"*'
         }
      }
   }
}