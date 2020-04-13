Set-StrictMode -Version Latest

#region include
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Classes/ProjectCompleter.ps1"
. "$here/../../Source/Classes/ProjectValidateAttribute.ps1"
. "$here/../../Source/Private/applyTypes.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/Set-VSTeamAPIVersion.ps1"
. "$here/../../Source/Public/$sut"
#endregion

Describe 'VSTeamServiceEndpointType' {
   $sampleFile = $(Get-Content "$PSScriptRoot\sampleFiles\serviceEndpointTypeSample.json" -Raw | ConvertFrom-Json)

   Mock Invoke-RestMethod { return $sampleFile }
   
   Mock _getInstance { return 'https://dev.azure.com/test' }   

   Context 'Get-VSTeamServiceEndpointType' {
      It 'should return all service endpoints types' {
         Get-VSTeamServiceEndpointType

         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/_apis/distributedtask/serviceendpointtypes?api-version=$(_getApiVersion DistributedTask)"
         }
      }

      It 'by Type should return all service endpoints types' {
         Get-VSTeamServiceEndpointType -Type azurerm

         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/_apis/distributedtask/serviceendpointtypes?api-version=$(_getApiVersion DistributedTask)" -and
            $Body.type -eq 'azurerm'
         }
      }
      
      It 'by Type and scheme should return all service endpoints types' {
         Get-VSTeamServiceEndpointType -Type azurerm -Scheme Basic

         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/_apis/distributedtask/serviceendpointtypes?api-version=$(_getApiVersion DistributedTask)" -and
            $Body.type -eq 'azurerm' -and
            $Body.scheme -eq 'Basic'
         }
      }
      
      It 'by scheme should return all service endpoints types' {
         Get-VSTeamServiceEndpointType -Scheme Basic

         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/_apis/distributedtask/serviceendpointtypes?api-version=$(_getApiVersion DistributedTask)" -and
            $Body.scheme -eq 'Basic'
         }
      }
   }
}