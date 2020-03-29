Set-StrictMode -Version Latest

#region include
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Private/applyTypes.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/Set-VSTeamAPIVersion.ps1"
. "$here/../../Source/Public/$sut"
#endregion

Describe 'VSTeamServiceEndpointType' {
   $sampleFile = "$PSScriptRoot\sampleFiles\serviceEndpointTypeSample.json"

   Mock _getInstance { return 'https://dev.azure.com/test' }
   
   # Mock the call to Get-Projects by the dynamic parameter for ProjectName
   Mock Invoke-RestMethod { return @() } -ParameterFilter { $Uri -like "*_apis/projects*" }

   Context 'Get-VSTeamServiceEndpointType' {
      Mock Invoke-RestMethod {
         return Get-Content $sampleFile | ConvertFrom-Json
      }

      It 'Should return all service endpoints types' {
         Get-VSTeamServiceEndpointType

         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/_apis/distributedtask/serviceendpointtypes?api-version=$(_getApiVersion DistributedTask)"
         }
      }
   }

   Context 'Get-VSTeamServiceEndpointType by Type' {
      Mock Invoke-RestMethod {
         return Get-Content $sampleFile | ConvertFrom-Json
      }

      It 'Should return all service endpoints types' {
         Get-VSTeamServiceEndpointType -Type azurerm

         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/_apis/distributedtask/serviceendpointtypes?api-version=$(_getApiVersion DistributedTask)" -and
            $Body.type -eq 'azurerm'
         }
      }
   }

   Context 'Get-VSTeamServiceEndpointType by Type and scheme' {
      Mock Invoke-RestMethod {
         return Get-Content $sampleFile | ConvertFrom-Json
      }

      It 'Should return all service endpoints types' {
         Get-VSTeamServiceEndpointType -Type azurerm -Scheme Basic

         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/_apis/distributedtask/serviceendpointtypes?api-version=$(_getApiVersion DistributedTask)" -and
            $Body.type -eq 'azurerm' -and
            $Body.scheme -eq 'Basic'
         }
      }
   }

   Context 'Get-VSTeamServiceEndpointType by scheme' {
      Mock Invoke-RestMethod {
         return Get-Content $sampleFile | ConvertFrom-Json
      }

      It 'Should return all service endpoints types' {
         Get-VSTeamServiceEndpointType -Scheme Basic

         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/_apis/distributedtask/serviceendpointtypes?api-version=$(_getApiVersion DistributedTask)" -and
            $Body.scheme -eq 'Basic'
         }
      }
   }
}