Set-StrictMode -Version Latest

Describe 'VSTeamPool' {
   BeforeAll {
      Import-Module SHiPS

      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      ## Arrange
      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'DistributedTask' }

   }

   Context 'Remove-VSTeamPool with parameters' {
      BeforeAll {
         Mock Invoke-RestMethod { Write-Host $ return $null }
      }

      it 'with ID should be called' {
         ## Act
         Remove-VSTeamPool -Id 5

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Delete' -and
            $Uri -eq "https://dev.azure.com/test/_apis/distributedtask/pools/5?api-version=$(_getApiVersion DistributedTask)"
         }
      }
   }
}