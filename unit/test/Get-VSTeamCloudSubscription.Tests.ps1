Set-StrictMode -Version Latest

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Private/applyTypes.ps1"
. "$here/../../Source/Public/$sut"

Describe 'Get-VSTeamCloudSubscription' {
   # Mock the call to Get-Projects by the dynamic parameter for ProjectName
   Mock Invoke-RestMethod { return @() } -ParameterFilter {
      $Uri -like "*_apis/projects*"
   }

   Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable

   Context 'service' {
      Mock Invoke-RestMethod {
         return @{value = 'subs' }
      }

      It 'should return all AzureRM Subscriptions' {
         Get-VSTeamCloudSubscription

         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/_apis/distributedtask/serviceendpointproxy/azurermsubscriptions?api-version=$([VSTeamVersions]::DistributedTask)"
         }
      }
   }
}

Describe 'Get-VSTeamCloudSubscription' {
   # Mock the call to Get-Projects by the dynamic parameter for ProjectName
   Mock Invoke-RestMethod { return @() } -ParameterFilter {
      $Uri -like "*_apis/projects*"
   }

   Mock _useWindowsAuthenticationOnPremise { return $true }
   Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' } -Verifiable

   Context 'server' {
      Mock Invoke-RestMethod { return @{value = 'subs' } }

      It 'should return all AzureRM Subscriptions' {
         Get-VSTeamCloudSubscription

         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "http://localhost:8080/tfs/defaultcollection/_apis/distributedtask/serviceendpointproxy/azurermsubscriptions?api-version=$([VSTeamVersions]::DistributedTask)"
         }
      }
   }

   # Must be last because it sets [VSTeamVersions]::Account to $null
   Context 'handles exception' {

      # Arrange
      Mock Invoke-RestMethod { throw 'Error' }

      It 'should return approvals' {

         # Act
         { Get-VSTeamCloudSubscription } | Should Throw
      }
   }
}