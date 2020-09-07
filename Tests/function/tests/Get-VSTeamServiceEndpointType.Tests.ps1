Set-StrictMode -Version Latest

Describe 'VSTeamServiceEndpointType' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      . "$baseFolder/Source/Private/applyTypes.ps1"
      . "$baseFolder/Source/Public/Set-VSTeamAPIVersion.ps1"

      $sampleFile = Open-SampleFile 'serviceEndpointTypeSample.json'

      Mock Invoke-RestMethod { return $sampleFile }

      Mock _getInstance { return 'https://dev.azure.com/test' }
   }

   Context 'Get-VSTeamServiceEndpointType' {
      It 'should return all service endpoints types' {
         Get-VSTeamServiceEndpointType

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/_apis/distributedtask/serviceendpointtypes?api-version=$(_getApiVersion DistributedTask)"
         }
      }

      It 'by Type should return all service endpoints types' {
         Get-VSTeamServiceEndpointType -Type azurerm

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/_apis/distributedtask/serviceendpointtypes?api-version=$(_getApiVersion DistributedTask)" -and
            $Body.type -eq 'azurerm'
         }
      }

      It 'by Type and scheme should return all service endpoints types' {
         Get-VSTeamServiceEndpointType -Type azurerm -Scheme Basic

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/_apis/distributedtask/serviceendpointtypes?api-version=$(_getApiVersion DistributedTask)" -and
            $Body.type -eq 'azurerm' -and
            $Body.scheme -eq 'Basic'
         }
      }

      It 'by scheme should return all service endpoints types' {
         Get-VSTeamServiceEndpointType -Scheme Basic

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/_apis/distributedtask/serviceendpointtypes?api-version=$(_getApiVersion DistributedTask)" -and
            $Body.scheme -eq 'Basic'
         }
      }
   }
}