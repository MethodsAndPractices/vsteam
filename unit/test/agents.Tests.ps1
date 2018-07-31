Set-StrictMode -Version Latest

Get-Module VSTeam | Remove-Module -Force

Import-Module $PSScriptRoot\..\..\VSTeam.psd1 -Force

InModuleScope agents {
   $VSTeamVersionTable.Account = 'https://test.visualstudio.com'
   $VSTeamVersionTable.DistributedTask = '1.0-unitTest'

   $testAgent = [PSCustomObject]@{
      _links             = [PSCustomObject]@{}
      createdOn          = '2018-03-28T16:48:58.317Z'
      maxParallelism     = 1
      id                 = 102
      status             = 'Online'
      version            = '1.336.1'
      osDescription      = 'Linux'
      name               = 'Test_Agent'
      authorization      = [PSCustomObject]@{}
      systemCapabilities = [PSCustomObject]@{}
   }

   Describe 'agents' {
      . "$PSScriptRoot\..\..\src\teamspsdrive.ps1"

      Context 'Get-VSTeamAgents' {
         Mock Invoke-RestMethod { return [PSCustomObject]@{
               count = 1
               value = $testAgent
            }
         }

         it 'Should return all the pools' {
            Get-VSTeamAgent -PoolId 1 

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://test.visualstudio.com/_apis/distributedtask/pools/1/agents/?api-version=$($VSTeamVersionTable.DistributedTask)"
            }
         }
      }

      Context 'Get-VSTeamAgents PoolID from pipeline by value' {
         Mock Invoke-RestMethod { return [PSCustomObject]@{
               count = 1
               value = $testAgent
            }
         }

         it 'Should return all the pools' {
            1 | Get-VSTeamAgent 

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://test.visualstudio.com/_apis/distributedtask/pools/1/agents/?api-version=$($VSTeamVersionTable.DistributedTask)"
            }
         }
      }

      Context 'Get-VSTeamPool with id parameter' {
         Mock Invoke-RestMethod { return $testAgent }

         it 'Should return all the pools' {
            Get-VSTeamAgent -PoolId 1 -id 1

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://test.visualstudio.com/_apis/distributedtask/pools/1/agents/1?api-version=$($VSTeamVersionTable.DistributedTask)"
            }
         }
      }

      Context 'Remove-VSTeamAgent by ID' {
         Mock Invoke-RestMethod

         It 'should remove the agent with passed in Id' {
            Remove-VSTeamAgent -Pool 36 -Id 950 -Force

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Method -eq 'Delete' -and
               $Uri -eq "https://test.visualstudio.com/_apis/distributedtask/pools/36/agents/950?api-version=$($VSTeamVersionTable.DistributedTask)"
            }
         }
      }
   }
}