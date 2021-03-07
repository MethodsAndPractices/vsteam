Set-StrictMode -Version Latest

Describe 'VSTeamPool' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      ## Arrange
      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'DistributedTaskReleased' }
   }

   Context 'Get-VSTeamPool with no parameters' {
      BeforeAll {
         Mock Invoke-RestMethod { Open-SampleFile 'Get-VSTeamPool.json' }
         Mock Invoke-RestMethod { Open-SampleFile 'Get-VSTeamPool.json' -Index 1 } -ParameterFilter {
            $Uri -like "*101*" 
         }
      }

      it 'with no parameters should return all the pools' {
         ## Act
         Get-VSTeamPool

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/_apis/distributedtask/pools?api-version=$(_getApiVersion DistributedTaskReleased)"
         }
      }

      it 'with id parameter should return all the pools' {
         ## Act
         Get-VSTeamPool -id 101

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/_apis/distributedtask/pools/101?api-version=$(_getApiVersion DistributedTaskReleased)"
         }
      }
   }
}