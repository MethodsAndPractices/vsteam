Set-StrictMode -Version Latest

Describe 'VSTeamServiceEndpointType' {
   BeforeAll {
      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProjectCache.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectCompleter.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectValidateAttribute.ps1"
      . "$PSScriptRoot/../../Source/Private/applyTypes.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Public/Set-VSTeamAPIVersion.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"

      $sampleFile = $(Get-Content "$PSScriptRoot\sampleFiles\serviceEndpointTypeSample.json" -Raw | ConvertFrom-Json)

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