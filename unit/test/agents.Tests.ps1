Set-StrictMode -Version Latest

InModuleScope VSTeam {
   [VSTeamVersions]::Account = 'https://dev.azure.com/test'
   [VSTeamVersions]::DistributedTask = '1.0-unitTest'

   $testAgent = [PSCustomObject]@{
      _links             = [PSCustomObject]@{}
      createdOn          = '2018-03-28T16:48:58.317Z'
      maxParallelism     = 1
      id                 = 102
      status             = 'Online'
      version            = '1.336.1'
      enabled            = $true
      osDescription      = 'Linux'
      name               = 'Test_Agent'
      authorization      = [PSCustomObject]@{}
      systemCapabilities = [PSCustomObject]@{}
   }

   Describe 'agents' {
      # Mock the call to Get-Projects by the dynamic parameter for ProjectName
      Mock Invoke-RestMethod { return @() } -ParameterFilter {
         $Uri -like "*_apis/projects*"
      }

      Context 'Get-VSTeamAgents' {
         Mock Invoke-RestMethod { return [PSCustomObject]@{
               count = 1
               value = $testAgent
            }
         }

         it 'Should return all the pools' {
            Get-VSTeamAgent -PoolId 1

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/_apis/distributedtask/pools/1/agents/?api-version=$([VSTeamVersions]::DistributedTask)"
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
               $Uri -eq "https://dev.azure.com/test/_apis/distributedtask/pools/1/agents/?api-version=$([VSTeamVersions]::DistributedTask)"
            }
         }
      }

      Context 'Get-VSTeamPool with id parameter' {
         Mock Invoke-RestMethod { return $testAgent }

         it 'Should return all the pools' {
            Get-VSTeamAgent -PoolId 1 -id 1

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/_apis/distributedtask/pools/1/agents/1?api-version=$([VSTeamVersions]::DistributedTask)"
            }
         }
      }

      Context 'Remove-VSTeamAgent by ID' {
         Mock Invoke-RestMethod

         It 'should remove the agent with passed in Id' {
            Remove-VSTeamAgent -Pool 36 -Id 950 -Force

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Method -eq 'Delete' -and
               $Uri -eq "https://dev.azure.com/test/_apis/distributedtask/pools/36/agents/950?api-version=$([VSTeamVersions]::DistributedTask)"
            }
         }
      }

      Context 'Remove-VSTeamAgent throws' {
         Mock Invoke-RestMethod { throw 'boom' }

         It 'should remove the agent with passed in Id' {
            { Remove-VSTeamAgent -Pool 36 -Id 950 -Force } | Should Throw
         }
      }

      Context 'Enable-VSTeamAgent by ID' {
         Mock Invoke-RestMethod

         It 'should enable the agent with passed in Id' {
            Enable-VSTeamAgent -Pool 36 -Id 950

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Method -eq 'Patch' -and
               $Uri -eq "https://dev.azure.com/test/_apis/distributedtask/pools/36/agents/950?api-version=$([VSTeamVersions]::DistributedTask)"
            }
         }
      }

      Context 'Enable-VSTeamAgent throws' {
         Mock Invoke-RestMethod { throw 'boom' }

         It 'should enable the agent with passed in Id' {
            { Enable-VSTeamAgent -Pool 36 -Id 950 } | Should Throw
         }
      }

      Context 'Disable-VSTeamAgent by ID' {
         Mock Invoke-RestMethod

         It 'should disable the agent with passed in Id' {
            Disable-VSTeamAgent -Pool 36 -Id 950

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Method -eq 'Patch' -and
               $Uri -eq "https://dev.azure.com/test/_apis/distributedtask/pools/36/agents/950?api-version=$([VSTeamVersions]::DistributedTask)"
            }
         }
      }

      Context 'Disable-VSTeamAgent throws' {
         Mock Invoke-RestMethod { throw 'boom' }

         It 'should disable the agent with passed in Id' {
            { Disable-VSTeamAgent -Pool 36 -Id 950 } | Should Throw
         }
      }
   }
}