Set-StrictMode -Version Latest

#region include
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Private/applyTypes.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/Get-VSTeamUserEntitlement.ps1"
. "$here/../../Source/Public/$sut"
#endregion

Describe "VSTeamUserEntitlement" {
   Context 'Add-VSTeamUserEntitlement' {
      Mock _getApiVersion { return 'VSTS' }
      # This will cause the call the _getProject to be skipped
      Mock _hasProjectCacheExpired { return $false }
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