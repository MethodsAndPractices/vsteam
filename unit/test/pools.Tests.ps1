Set-StrictMode -Version Latest

Get-Module VSTeam | Remove-Module -Force
Import-Module $PSScriptRoot\..\..\src\team.psm1 -Force
Import-Module $PSScriptRoot\..\..\src\pools.psm1 -Force

InModuleScope pools {
   $VSTeamVersionTable.Account = 'https://test.visualstudio.com'
   $VSTeamVersionTable.DistributedTask = '1.0-unitTest'

   Describe 'pools' {
      Context 'Get-VSTeamPool with no parameters' {
         Mock Invoke-RestMethod { return [PSCustomObject]@{
               value = [PSCustomObject]@{
                  createdBy            = [PSCustomObject]@{}
                  administratorsGroup  = [PSCustomObject]@{}
                  serviceAccountsGroup = [PSCustomObject]@{}
               }
            }}

         it 'Should return all the pools' {
            Get-VSTeamPool

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://test.visualstudio.com/_apis/distributedtask/pools/?api-version=$($VSTeamVersionTable.DistributedTask)"
            }
         }
      }

      Context 'Get-VSTeamPool with id parameter' {
         Mock Invoke-RestMethod { return [PSCustomObject]@{
               createdBy            = [PSCustomObject]@{}
               administratorsGroup  = [PSCustomObject]@{}
               serviceAccountsGroup = [PSCustomObject]@{}
            }}

         it 'Should return all the pools' {
            Get-VSTeamPool -id '1'

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://test.visualstudio.com/_apis/distributedtask/pools/1?api-version=$($VSTeamVersionTable.DistributedTask)"
            }
         }
      }
   }
}