Set-StrictMode -Version Latest

Get-Module VSTeam | Remove-Module -Force
Import-Module $PSScriptRoot\..\..\src\team.psm1 -Force
Import-Module $PSScriptRoot\..\..\src\cloudSubscriptions.psm1 -Force

InModuleScope cloudSubscriptions {
   
   Describe 'CloudSubscriptions vsts' {
      $VSTeamVersionTable.Account = 'https://test.visualstudio.com'

      Context 'Get-VSTeamCloudSubscription' {
         Mock Invoke-RestMethod { 
            return @{value = 'subs'}
         }

         It 'should return all AzureRM Subscriptions' {
            Get-VSTeamCloudSubscription

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://test.visualstudio.com/_apis/distributedtask/serviceendpointproxy/azurermsubscriptions/?api-version=$($VSTeamVersionTable.DistributedTask)"
            }
         }
      }
   }

   Describe 'CloudSubscriptions TFS' {
      Mock _useWindowsAuthenticationOnPremise { return $true }
      $VSTeamVersionTable.Account = 'http://localhost:8080/tfs/defaultcollection'
      
      Context 'Get-VSTeamCloudSubscription' {
         Mock Invoke-RestMethod { return @{value = 'subs'}}

         It 'should return all AzureRM Subscriptions' {
            Get-VSTeamCloudSubscription

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/_apis/distributedtask/serviceendpointproxy/azurermsubscriptions/?api-version=$($VSTeamVersionTable.DistributedTask)"
            }
         }
      }

      # Must be last because it sets $VSTeamVersionTable.Account to $null
      Context '_buildURL handles exception' {
         
         # Arrange
         $VSTeamVersionTable.Account = $null
         
         It 'should return approvals' {
         
            # Act
            { _buildURL } | Should Throw
         }
      }
   }
}