Set-StrictMode -Version Latest

Get-Module team | Remove-Module -Force
Import-Module $PSScriptRoot\..\..\src\team.psm1 -Force
Import-Module $PSScriptRoot\..\..\src\cloudSubscriptions.psm1 -Force

InModuleScope cloudSubscriptions {
   $VSTeamVersionTable.Account = 'https://test.visualstudio.com'

   Describe 'CloudSubscriptionns' {
      Context 'Get-VSTeamCloudSubscription' {
         Mock Invoke-RestMethod { return @{value='subs'}}

         It 'should return all AzureRM Subscriptions' {
            Get-VSTeamCloudSubscription

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq 'https://test.visualstudio.com/_apis/distributedtask/serviceendpointproxy/azurermsubscriptions'
            }
         }
      }
   }
}