Set-StrictMode -Version Latest

Describe 'VSTeamServiceEndpointType' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock Invoke-RestMethod { Open-SampleFile 'serviceEndpointTypeSample.json' }
   }

   Context 'Get-VSTeamServiceEndpointType' {
      It 'should return all service endpoints types' {
         ## Act
         Get-VSTeamServiceEndpointType

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/_apis/distributedtask/serviceendpointtypes?api-version=$(_getApiVersion DistributedTask)"
         }
      }

      It 'by Type should return all service endpoints types' {
         ## Act
         Get-VSTeamServiceEndpointType -Type azurerm

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/_apis/distributedtask/serviceendpointtypes?api-version=$(_getApiVersion DistributedTask)" -and
            $Body.type -eq 'azurerm'
         }
      }

      It 'by Type and scheme should return all service endpoints types' {
         ## Act
         Get-VSTeamServiceEndpointType -Type azurerm -Scheme Basic

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/_apis/distributedtask/serviceendpointtypes?api-version=$(_getApiVersion DistributedTask)" -and
            $Body.type -eq 'azurerm' -and
            $Body.scheme -eq 'Basic'
         }
      }

      It 'by scheme should return all service endpoints types' {
         ## Act
         Get-VSTeamServiceEndpointType -Scheme Basic

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/_apis/distributedtask/serviceendpointtypes?api-version=$(_getApiVersion DistributedTask)" -and
            $Body.scheme -eq 'Basic'
         }
      }
   }
}