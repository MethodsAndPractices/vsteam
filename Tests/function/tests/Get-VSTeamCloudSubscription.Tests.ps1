Set-StrictMode -Version Latest

Describe 'VSTeamCloudSubscription' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
   }
   
   Context 'Get-VSTeamCloudSubscription' {
      BeforeAll {
         Mock Invoke-RestMethod { return @{value = 'subs' } }
         Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'DistributedTask' }
      }

      Context 'Services' {
         BeforeAll {
            Mock _getInstance { return 'https://dev.azure.com/test' }
         }

         It 'should return all AzureRM Subscriptions' {
            Get-VSTeamCloudSubscription

            Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/_apis/distributedtask/serviceendpointproxy/azurermsubscriptions?api-version=$(_getApiVersion DistributedTask)"
            }
         }
      }

      Context 'Server' {
         BeforeAll {
            Mock _useWindowsAuthenticationOnPremise { return $true }
            Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' }
         }

         It 'should return all AzureRM Subscriptions' {
            Get-VSTeamCloudSubscription

            Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/_apis/distributedtask/serviceendpointproxy/azurermsubscriptions?api-version=$(_getApiVersion DistributedTask)"
            }
         }
      }
   }
}