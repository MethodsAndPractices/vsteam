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
   Context 'Update-VSTeamUserEntitlement' {
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

      It 'Should update a user' {
         Update-VSTeamUserEntitlement -License 'Stakeholder' -LicensingSource msdn -MSDNLicenseType enterprise -Email 'test@user.com' -Force
            
         Assert-MockCalled _callAPI -Exactly -Times 1 -Scope It -ParameterFilter {
            $Method -eq 'Patch' -and
            $subDomain -eq 'vsaex' -and
            $id -eq '00000000-0000-0000-0000-000000000000' -and
            $resource -eq 'userentitlements' -and
            $version -eq $(_getApiVersion MemberEntitlementManagement)
         }
      }

      It 'update user with invalid email should throw' {
         { Update-VSTeamUserEntitlement -Email 'not@found.com' -License 'Express' -Force } | Should Throw
      }

      It 'update user with invalid id should throw' {
         { Update-VSTeamUserEntitlement -Id '11111111-0000-0000-0000-000000000000'  -License 'Express' -Force } | Should Throw
      }

      # Context 'Add-VSTeamUserEntitlement' {
      #    $obj = @{
      #       accessLevel         = @{
      #          accountLicenseType = 'earlyAdopter'
      #          licensingSource    = 'msdn'
      #          msdnLicenseType    = 'enterprise'
      #       }
      #       user                = @{
      #          principalName = 'test@user.com'
      #          subjectKind   = 'user'
      #       }
      #       projectEntitlements = @{
      #          group      = @{
      #             groupType = 'ProjectContributor'
      #          }
      #          projectRef = @{
      #             id = $null
      #          }
      #       }
      #    }

      #    $expected = $obj | ConvertTo-Json

      #    Mock _callAPI -ParameterFilter {
      #       $Method -eq 'Post' -and
      #       $Body -eq $expected
      #    }

      #    Add-VSTeamUserEntitlement -License earlyAdopter -LicensingSource msdn -MSDNLicenseType enterprise -Email 'test@user.com'

      #    It 'Should add a user' {
      #       Assert-VerifiableMock
      #    }
      # }
   }
}