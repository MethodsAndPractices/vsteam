Set-StrictMode -Version Latest

Get-Module VSTeam | Remove-Module -Force
Import-Module $PSScriptRoot\..\..\src\team.psm1 -Force
Import-Module $PSScriptRoot\..\..\src\queues.psm1 -Force

InModuleScope queues {
   $VSTeamVersionTable.Account = 'https://test.visualstudio.com'

   Describe 'Queues' {
      . "$PSScriptRoot\mockProjectNameDynamicParamNoPSet.ps1"

      Context 'Get-VSTeamQueue with no parameters' {
         Mock Invoke-RestMethod { return @{
               value=@{
                  pool=@{}
               }
            }}

         it 'Should return all the queues' {
            Get-VSTeamQueue -ProjectName project

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://test.visualstudio.com/project/_apis/distributedtask/queues/?api-version=$($VSTeamVersionTable.DistributedTask)"
            }
         }
      }

      Context 'Get-VSTeamQueue with queueName parameter' {
         Mock Invoke-RestMethod { return @{
               value=@{
                  pool=@{}
               }
            }}

         it 'Should return all the queues' {
            Get-VSTeamQueue -projectName project -queueName 'Hosted'

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://test.visualstudio.com/project/_apis/distributedtask/queues/?api-version=$($VSTeamVersionTable.DistributedTask)&queueName=Hosted"
            }
         }
      }

      Context 'Get-VSTeamQueue with actionFilter parameter' {
         Mock Invoke-RestMethod { return @{
               value=@{
                  pool=@{}
               }
            }}

         it 'Should return all the queues' {
            Get-VSTeamQueue -projectName project -actionFilter 'None'

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://test.visualstudio.com/project/_apis/distributedtask/queues/?api-version=$($VSTeamVersionTable.DistributedTask)&actionFilter=None"
            }
         }
      }

      Context 'Get-VSTeamQueue with actionFilter & queueName parameter' {
         Mock Invoke-RestMethod { return @{
               value=@{
                  pool=@{}
               }
            }}

         it 'Should return all the queues' {
            Get-VSTeamQueue -projectName project -actionFilter 'None' -queueName 'Hosted'

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://test.visualstudio.com/project/_apis/distributedtask/queues/?api-version=$($VSTeamVersionTable.DistributedTask)&actionFilter=None&queueName=Hosted"
            }
         }
      }

      Context 'Get-VSTeamQueue' {
         Mock Invoke-RestMethod { return @{
               pool=@{}
            }}

         It 'should return requested queue' {
            Get-VSTeamQueue -projectName project -queueId 3

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://test.visualstudio.com/project/_apis/distributedtask/queues/3?api-version=$($VSTeamVersionTable.DistributedTask)"
            }
         }
      }
   }
}