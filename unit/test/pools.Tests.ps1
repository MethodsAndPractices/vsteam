Set-StrictMode -Version Latest

Get-Module VSTeam | Remove-Module -Force
Import-Module $PSScriptRoot\..\..\src\team.psm1 -Force
Import-Module $PSScriptRoot\..\..\src\pools.psm1 -Force

InModuleScope pools {
   $VSTeamVersionTable.Account = 'https://test.visualstudio.com'
   $VSTeamVersionTable.DistributedTask = '1.0-unitTest'

   $testPool = [PSCustomObject]@{
      owner     = [PSCustomObject]@{}
      createdBy = [PSCustomObject]@{}
      id        = 1
      size      = 1
      isHosted  = $true
      Name      = 'Hosted'
   }

   Describe 'pools' {

      Context 'Get-VSTeamPool with no parameters' {
         Mock Invoke-RestMethod { return [PSCustomObject]@{
               count = 1
               value = $testPool
            }
         }

         it 'Should return all the pools' {
            Get-VSTeamPool

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://test.visualstudio.com/_apis/distributedtask/pools/?api-version=$($VSTeamVersionTable.DistributedTask)"
            }
         }
      }

      Context 'Get-VSTeamPool with id parameter' {
         Mock Invoke-RestMethod { return $testPool }

         it 'Should return all the pools' {
            Get-VSTeamPool -id '1'

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://test.visualstudio.com/_apis/distributedtask/pools/1?api-version=$($VSTeamVersionTable.DistributedTask)"
            }
         }
      }
   }
}