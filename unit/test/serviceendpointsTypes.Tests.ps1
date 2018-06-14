Set-StrictMode -Version Latest

Get-Module VSTeam | Remove-Module -Force
Import-Module $PSScriptRoot\..\..\src\team.psm1 -Force
Import-Module $PSScriptRoot\..\..\src\serviceendpointTypes.psm1 -Force

InModuleScope serviceendpointTypes {
   $sampleFile = "$PSScriptRoot\serviceEndpointTypeSample.json"

   $VSTeamVersionTable.Account = 'https://test.visualstudio.com'

   Describe 'serviceendpointTypes' {
      Context 'Get-VSTeamServiceEndpointTypes' {
         Mock Invoke-RestMethod {
            return Get-Content $sampleFile | ConvertFrom-Json
         }

         It 'Should return all service endpoints types' {
            Get-VSTeamServiceEndpointType

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://test.visualstudio.com/_apis/distributedtask/serviceendpointtypes/?api-version=$($VSTeamVersionTable.DistributedTask)"
            }
         }
      }

      Context 'Get-VSTeamServiceEndpointTypes by Type' {
         Mock Invoke-RestMethod {
            return Get-Content $sampleFile | ConvertFrom-Json
         }

         It 'Should return all service endpoints types' {
            Get-VSTeamServiceEndpointType -Type azurerm

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://test.visualstudio.com/_apis/distributedtask/serviceendpointtypes/?api-version=$($VSTeamVersionTable.DistributedTask)" -and
               $Body.type -eq 'azurerm'
            }
         }
      }

      Context 'Get-VSTeamServiceEndpointTypes by Type and scheme' {
         Mock Invoke-RestMethod {
            return Get-Content $sampleFile | ConvertFrom-Json
         }

         It 'Should return all service endpoints types' {
            Get-VSTeamServiceEndpointType -Type azurerm -Scheme Basic

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://test.visualstudio.com/_apis/distributedtask/serviceendpointtypes/?api-version=$($VSTeamVersionTable.DistributedTask)" -and
               $Body.type -eq 'azurerm' -and
               $Body.scheme -eq 'Basic'
            }
         }
      }

      Context 'Get-VSTeamServiceEndpointTypes by scheme' {
         Mock Invoke-RestMethod {
            return Get-Content $sampleFile | ConvertFrom-Json
         }

         It 'Should return all service endpoints types' {
            Get-VSTeamServiceEndpointType -Scheme Basic

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://test.visualstudio.com/_apis/distributedtask/serviceendpointtypes/?api-version=$($VSTeamVersionTable.DistributedTask)" -and
               $Body.scheme -eq 'Basic'
            }
         }
      }
   }
}