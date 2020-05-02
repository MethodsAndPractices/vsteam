Set-StrictMode -Version Latest

#region include
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Classes/ProjectCompleter.ps1"
. "$here/../../Source/Classes/ProjectValidateAttribute.ps1"
. "$here/../../Source/Private/applyTypes.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/Get-VSTeamUserEntitlement.ps1"
. "$here/../../Source/Public/$sut"
#endregion

Describe "VSTeamUserEntitlement" {
   Context 'Add-VSTeamUserEntitlement' {
      [VSTeamVersions]::ModuleVersion = '0.0.0'
      Mock _getApiVersion { return 'VSTS' }
      Mock _getProjects { return @() }
      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'MemberEntitlementManagement' }

      $obj = @{
         accessLevel         = @{
            accountLicenseType = 'earlyAdopter'
            licensingSource    = 'msdn'
            msdnLicenseType    = 'enterprise'
         }
         user                = @{
            principalName = 'test@user.com'
            subjectKind   = 'user'
         }
         projectEntitlements = @{
            group      = @{
               groupType = 'ProjectContributor'
            }
            projectRef = @{
               id = $null
            }
         }
      }

      $expected = $obj | ConvertTo-Json

      Mock _callAPI -ParameterFilter {
         $Method -eq 'Post' -and
         $Body -eq $expected
      }

      Add-VSTeamUserEntitlement -License earlyAdopter -LicensingSource msdn -MSDNLicenseType enterprise -Email 'test@user.com'

      It 'Should add a user' {
         Assert-VerifiableMock
      }
   }
}