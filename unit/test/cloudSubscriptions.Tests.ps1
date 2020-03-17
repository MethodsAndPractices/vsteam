Set-StrictMode -Version Latest

$env:Testing=$true
InModuleScope VSTeam {

   Describe 'CloudSubscriptions vsts' {
      # Mock the call to Get-Projects by the dynamic parameter for ProjectName
      Mock Invoke-RestMethod { return @() } -ParameterFilter {
         $Uri -like "*_apis/projects*"
      }

      Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable

      Context 'Get-VSTeamCloudSubscription' {
         Mock Invoke-RestMethod {
            return @{value = 'subs'}
         }

         It 'should return all AzureRM Subscriptions' {
            Get-VSTeamCloudSubscription

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/_apis/distributedtask/serviceendpointproxy/azurermsubscriptions?api-version=$([VSTeamVersions]::DistributedTask)"
            }
         }
      }
   }

   Describe 'CloudSubscriptions TFS' {
      # Mock the call to Get-Projects by the dynamic parameter for ProjectName
      Mock Invoke-RestMethod { return @() } -ParameterFilter {
         $Uri -like "*_apis/projects*"
      }

      Mock _useWindowsAuthenticationOnPremise { return $true }
      Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' } -Verifiable

      Context 'Get-VSTeamCloudSubscription' {
         Mock Invoke-RestMethod { return @{value = 'subs'}}

         It 'should return all AzureRM Subscriptions' {
            Get-VSTeamCloudSubscription

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/_apis/distributedtask/serviceendpointproxy/azurermsubscriptions?api-version=$([VSTeamVersions]::DistributedTask)"
            }
         }
      }

      # Must be last because it sets [VSTeamVersions]::Account to $null
      Context '_buildURL handles exception' {

         # Arrange
         [VSTeamVersions]::Account = $null

         It 'should return approvals' {

            # Act
            { _buildURL } | Should Throw
         }
      }
   }
}