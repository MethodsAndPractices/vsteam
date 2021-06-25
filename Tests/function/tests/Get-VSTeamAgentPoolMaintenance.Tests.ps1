Set-StrictMode -Version Latest

Describe 'VSTeamPool' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      ## Arrange
      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'DistributedTask' }

      $multipleResults = Open-SampleFile 'agentPoolMaintenanceMultipleResult.json'
   }

   Context 'Get-VSTeamAgentPoolMaintenance with parameters' {
      BeforeAll {
         Mock Invoke-RestMethod { return $multipleResults }
      }

      it 'should return schedule' {
         ## Act
         Get-VSTeamAgentPoolMaintenance -Id 14

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Get' -and
            $Uri -eq "https://dev.azure.com/test/_apis/distributedtask/pools/14/maintenancedefinitions?api-version=$(_getApiVersion DistributedTask)"
         }
      }
   }
}