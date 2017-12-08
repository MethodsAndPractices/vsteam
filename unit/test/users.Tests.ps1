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

      Context 'Get-VSTeamUser with select for projects' {  
         Mock  _get { return [PSCustomObject]@{ 
               count = 1
               value = [PSCustomObject]@{ accessLevel = [PSCustomObject]@{ } }
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
   }
}