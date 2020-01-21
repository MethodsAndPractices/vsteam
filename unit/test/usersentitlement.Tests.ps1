Set-StrictMode -Version Latest

InModuleScope VSTeam {
   [VSTeamVersions]::Account = 'https://dev.azure.com/test'

   Describe "Users TFS Errors" {
      # Mock the call to Get-Projects by the dynamic parameter for ProjectName
      Mock Invoke-RestMethod { return @() } -ParameterFilter {
         $Uri -like "*_apis/projects*"
      }

      Context 'Get-VSTeamUserEntitlement' {
         Mock _callAPI { throw 'Should not be called' } -Verifiable

         It 'Should throw' {
            Set-VSTeamAPIVersion TFS2017

            { Get-VSTeamUserEntitlement } | Should Throw
         }

         It '_callAPI should not be called' {
            Assert-MockCalled _callAPI -Exactly 0
         }
      }
   }

   Describe "Users VSTS" {
      # Mock the call to Get-Projects by the dynamic parameter for ProjectName
      Mock Invoke-RestMethod { return @() } -ParameterFilter {
         $Uri -like "*_apis/projects*"
      }

      . "$PSScriptRoot\mocks\mockProjectDynamicParamMandatoryFalse.ps1"

      # Must be defined or call will throw error
      [VSTeamVersions]::MemberEntitlementManagement = '4.1-preview'

      Context 'Get-VSTeamUserEntitlement no parameters' {
         Mock  _callAPI { return [PSCustomObject]@{
               members = [PSCustomObject]@{ accessLevel = [PSCustomObject]@{ } }
            }
         }

         It 'Should return users' {
            Get-VSTeamUserEntitlement

            # Make sure it was called with the correct URI
            Assert-MockCalled _callAPI -Exactly 1 -ParameterFilter {
               $url -eq "https://vsaex.dev.azure.com/test/_apis/userentitlements?api-version=$([VSTeamVersions]::MemberEntitlementManagement)&top=100&skip=0"
            }
         }
      }

      Context 'Get-VSTeamUserEntitlement By ID' {
         Mock  _callAPI {
            return [PSCustomObject]@{
               accessLevel = [PSCustomObject]@{ }
               email       = 'fake@email.com'
            }
         }

         It 'Should return users with projects' {
            Get-VSTeamUserEntitlement -Id '00000000-0000-0000-0000-000000000000'

            # Make sure it was called with the correct URI
            Assert-MockCalled _callAPI -Exactly 1 -ParameterFilter {
               $subDomain -eq 'vsaex' -and
               $id -eq '00000000-0000-0000-0000-000000000000' -and
               $resource -eq 'userentitlements'
            }
         }
      }

      Context 'Get-VSTeamUserEntitlement with select for projects' {
         Mock  _callAPI {
            return [PSCustomObject]@{
               members = [PSCustomObject]@{
                  accessLevel = [PSCustomObject]@{ }
                  email       = 'fake@email.com'
               }
            }
         }

         It 'Should return users with projects' {
            Get-VSTeamUserEntitlement -Select Projects

            # Make sure it was called with the correct URI
            Assert-MockCalled _callAPI -Exactly 1 -ParameterFilter {
               $url -eq "https://vsaex.dev.azure.com/test/_apis/userentitlements?api-version=$([VSTeamVersions]::MemberEntitlementManagement)&top=100&skip=0&Select=Projects"
            }
         }
      }

      Context 'Remove-VSTeamUserEntitlement by Id' {
         Mock _callAPI -ParameterFilter {
            $Method -eq 'Delete' -and
            $subDomain -eq 'vsaex' -and
            $id -eq '00000000-0000-0000-0000-000000000000' -and
            $resource -eq 'userentitlements' -and
            $version -eq [VSTeamVersions]::MemberEntitlementManagement
         }

         Mock _callAPI {
            return [PSCustomObject]@{
               accessLevel = [PSCustomObject]@{ }
               email       = 'test@user.com'
               userName    = 'Test User'
               id          = '00000000-0000-0000-0000-000000000000'
            }
         }

         Remove-VSTeamUserEntitlement -UserId '00000000-0000-0000-0000-000000000000' -Force

         It 'Should remove user' {
            Assert-MockCalled _callAPI -Exactly 1 -ParameterFilter {
               $subDomain -eq 'vsaex' -and
               $id -eq '00000000-0000-0000-0000-000000000000' -and
               $resource -eq 'userentitlements' -and
               $method -eq 'Delete' -and
               $version -eq [VSTeamVersions]::MemberEntitlementManagement
            }
         }
      }

      Context 'Remove-VSTeamUserEntitlement by email' {
         Mock _callAPI -ParameterFilter {
            $Method -eq 'Delete' -and
            $subDomain -eq 'vsaex' -and
            $id -eq '00000000-0000-0000-0000-000000000000' -and
            $resource -eq 'userentitlements' -and
            $version -eq [VSTeamVersions]::MemberEntitlementManagement
         }

         Mock _callAPI {
            return [PSCustomObject]@{
               members = [PSCustomObject]@{
                  accessLevel = [PSCustomObject]@{ }
                  email       = 'test@user.com'
                  userName    = 'Test User'
                  id          = '00000000-0000-0000-0000-000000000000'
               }
            }
         }

         Remove-VSTeamUserEntitlement -Email 'test@user.com' -Force

         It 'Should remmove user' {
            Assert-MockCalled _callAPI -Exactly 1 -ParameterFilter {
               $Method -eq 'Delete' -and
               $subDomain -eq 'vsaex' -and
               $id -eq '00000000-0000-0000-0000-000000000000' -and
               $resource -eq 'userentitlements' -and
               $version -eq [VSTeamVersions]::MemberEntitlementManagement
            }
         }
      }

      Context 'Remove-VSTeamUserEntitlement by invalid email' {
         Mock _callAPI { return [PSCustomObject]@{
               members = [PSCustomObject]@{
                  accessLevel = [PSCustomObject]@{ }
                  email       = 'test@user.com'
                  id          = '00000000-0000-0000-0000-000000000000'
               }
            }
         }

         It 'Should throw' {
            { Remove-VSTeamUserEntitlement -Email 'not@found.com' -Force } | Should Throw
         }
      }

      Context 'Update-VSTeamUserEntitlement by invalid email' {
         Mock _callAPI { return [PSCustomObject]@{
               members = [PSCustomObject]@{
                  accessLevel = [PSCustomObject]@{ }
                  email       = 'test@user.com'
                  id          = '00000000-0000-0000-0000-000000000000'
               }
            }
         }

         It 'Update User with invalid email should throw' {
            { Update-VSTeamUserEntitlement -Email 'not@found.com' -License 'Express' -Force } | Should Throw
         }
      }

      Context 'Update-VSTeamUserEntitlement by invalid id' {
         Mock _callAPI { return [PSCustomObject]@{
               members = [PSCustomObject]@{
                  accessLevel = [PSCustomObject]@{ }
                  email       = 'test@user.com'
                  id          = '00000000-0000-0000-0000-000000000000'
               }
            }
         }

         It 'Update User with invalid id should throw' {
            { Update-VSTeamUserEntitlement -Id '11111111-0000-0000-0000-000000000000'  -License 'Express' -Force } | Should Throw
         }
      }

      Context 'Add-VSTeamUserEntitlement' {
         $obj = @{
            accessLevel         = @{
               accountLicenseType = 'earlyAdopter'
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

         Mock _callAPI -Verifiable -ParameterFilter {
            $Method -eq 'Post' -and
            $Body -eq $expected
         }

         Add-VSTeamUserEntitlement -License earlyAdopter -Email 'test@user.com'

         It 'Should add a user' {
            Assert-VerifiableMock
         }
      }

      Context 'Update user should update' {

         Mock _callAPI { return [PSCustomObject]@{
               members = [PSCustomObject]@{
                  accessLevel = [PSCustomObject]@{
                     accountLicenseType = "Stakeholder"
                  }
                  email       = 'test@user.com'
                  id          = '00000000-0000-0000-0000-000000000000'
               }
            }
         }

         Update-VSTeamUserEntitlement -License 'Stakeholder' -Email 'test@user.com' -Force

         It 'Should update a user' {
            Assert-MockCalled _callAPI -Exactly 1 -ParameterFilter {
               $Method -eq 'Patch' -and
               $subDomain -eq 'vsaex' -and
               $id -eq '00000000-0000-0000-0000-000000000000' -and
               $resource -eq 'userentitlements' -and
               $version -eq [VSTeamVersions]::MemberEntitlementManagement
            }

         }
      }
   }
}