Set-StrictMode -Version Latest

Get-Module VSTeam | Remove-Module -Force
Import-Module $PSScriptRoot\..\..\src\team.psm1 -Force
Import-Module $PSScriptRoot\..\..\src\users.psm1 -Force

InModuleScope users {
   $VSTeamVersionTable.Account = 'https://test.visualstudio.com'
   
   Describe "Users TFS Errors" {
      Context 'Get-VSTeamUser' {  
         Mock  _get { throw 'Should not be called' }

         It 'Should throw' {
            { Get-VSTeamUser } | Should Throw
         }
      }
   }

   Describe "Users VSTS" {

      # Must be defined or call will throw error
      $VSTeamVersionTable.MemberEntitlementManagement = '4.1-preview'

      Context 'Get-VSTeamUser no parameters' {  
         Mock  _get { return [PSCustomObject]@{ 
               count = 1
               value = [PSCustomObject]@{ accessLevel = [PSCustomObject]@{ } }
            } 
         }

         It 'Should return users' {
            Get-VSTeamUser 

            # Make sure it was called with the correct URI
            Assert-MockCalled _get -Exactly 1 -ParameterFilter {
               $url -eq "https://test.vsaex.visualstudio.com/_apis/userentitlements?api-version=$($VSTeamVersionTable.MemberEntitlementManagement)&top=100&skip=0"
            }
         }
      }

      Context 'Get-VSTeamUser By ID' {  
         Mock  _get { return [PSCustomObject]@{
               accessLevel = [PSCustomObject]@{ }
               email       = 'fake@email.com'
            } 
         }

         It 'Should return users with projects' {
            Get-VSTeamUser -Id '00000000-0000-0000-0000-000000000000'

            # Make sure it was called with the correct URI
            Assert-MockCalled _get -Exactly 1 -ParameterFilter {
               $url -eq "https://test.vsaex.visualstudio.com/_apis/userentitlements/00000000-0000-0000-0000-000000000000?api-version=$($VSTeamVersionTable.MemberEntitlementManagement)"
            }
         }
      }

      Context 'Get-VSTeamUser with select for projects' {  
         Mock  _get { return [PSCustomObject]@{ 
               count = 1
               value = [PSCustomObject]@{ 
                  accessLevel = [PSCustomObject]@{ }
                  email       = 'fake@email.com'
               }
            } 
         }

         It 'Should return users with projects' {
            Get-VSTeamUser -Select Projects

            # Make sure it was called with the correct URI
            Assert-MockCalled _get -Exactly 1 -ParameterFilter {
               $url -eq "https://test.vsaex.visualstudio.com/_apis/userentitlements?api-version=$($VSTeamVersionTable.MemberEntitlementManagement)&top=100&skip=0&Select=Projects"
            }
         }
      }

      Context 'Remove-VSTeamUser by Id' {
         Mock _delete

         Remove-VSTeamUser -UserId '00000000-0000-0000-0000-000000000000' -Force

         It 'Should remmove user' {
            Assert-MockCalled _delete -Exactly 1 -ParameterFilter {
               $url -eq "https://test.vsaex.visualstudio.com/_apis/userentitlements/00000000-0000-0000-0000-000000000000?api-version=$($VSTeamVersionTable.MemberEntitlementManagement)"
            }
         }
      }

      Context 'Remove-VSTeamUser by email' {
         Mock _delete
         Mock  _get { return [PSCustomObject]@{ 
               count = 1
               value = [PSCustomObject]@{ 
                  accessLevel = [PSCustomObject]@{ }
                  email       = 'test@user.com'
                  id          = '00000000-0000-0000-0000-000000000000'
               }
            } 
         }

         Remove-VSTeamUser -Email 'test@user.com' -Force

         It 'Should remmove user' {
            Assert-MockCalled _delete -Exactly 1 -ParameterFilter {
               $url -eq "https://test.vsaex.visualstudio.com/_apis/userentitlements/00000000-0000-0000-0000-000000000000?api-version=$($VSTeamVersionTable.MemberEntitlementManagement)"
            }
         }
      }

      Context 'Remove-VSTeamUser by invalid email' {
         Mock _delete
         Mock  _get { return [PSCustomObject]@{ 
               count = 1
               value = [PSCustomObject]@{ 
                  accessLevel = [PSCustomObject]@{ }
                  email       = 'test@user.com'
                  id          = '00000000-0000-0000-0000-000000000000'
               }
            } 
         }

         It 'Should throw' {
            { Remove-VSTeamUser -Email 'not@found.com' -Force } | Should Throw
         }
      }

      Context 'Add-VSTeamUser' {
         $obj = @{
            accessLevel = @{
               accountLicenseType = 'earlyAdopter'
            }
            user = @{
               principalName = 'test@user.com'
               subjectKind = 'user'
            }
            projectEntitlements = @{
               group = @{
                  groupType = 'ProjectContributor'
               }
               projectRef = @{
                  id = $null
               }
            }
         }
   
         $expected = $obj | ConvertTo-Json

         Mock _post -Verifiable -ParameterFilter {
            $Body -eq $expected
         }

         Add-VSTeamUser -License earlyAdopter -Email 'test@user.com'

         It 'Should add a user' {
            Assert-VerifiableMocks
         }
      }
   }
}