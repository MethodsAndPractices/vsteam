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

   Context 'Add-VSTeamUserEntitlement' {
      BeforeAll {
         [VSTeamVersions]::ModuleVersion = '0.0.0'
         Mock _getProjects { return @() }
         Mock _getInstance { return 'https://dev.azure.com/test' }
         Mock _getApiVersion { return 'VSTS' }

         Mock _callAPI -ParameterFilter {
            $Method -eq 'Post' -and
            $SubDomain -eq 'vsaex' -and
            $Body -like '*"principalName": "test@user.com"*' -and
            $Body -like '*"subjectKind": "user"*'
         } -Verifiable
      }

      It 'Should add a user' {
         Add-VSTeamUserEntitlement -License earlyAdopter -LicensingSource msdn -MSDNLicenseType enterprise -Email 'test@user.com'

         Should -InvokeVerifiable
      }
   }
}