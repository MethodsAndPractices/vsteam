Set-StrictMode -Version Latest

Get-Module team | Remove-Module -Force
Import-Module $PSScriptRoot\..\..\src\queues.psm1 -Force

InModuleScope queues {
   $env:TEAM_ACCT = 'https://test.visualstudio.com'

   Describe 'Queues' {
      . "$PSScriptRoot\mockProjectNameDynamicParamNoPSet.ps1"

      Context 'Get-Queue with no parameters' {
         Mock Invoke-RestMethod { return @{
               value=@{
                  pool=@{}
               }
            }}

         it 'Should return all the queues' {
            Get-Queue -ProjectName project

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq 'https://test.visualstudio.com/project/_apis/distributedtask/queues?api-version=3.0-preview.1'
            }
         }
      }

      Context 'Get-Queue with queueName parameter' {
         Mock Invoke-RestMethod { return @{
               value=@{
                  pool=@{}
               }
            }}

         it 'Should return all the queues' {
            Get-Queue -projectName project -queueName 'Hosted'

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq 'https://test.visualstudio.com/project/_apis/distributedtask/queues?api-version=3.0-preview.1&queueName=Hosted'
            }
         }
      }

      Context 'Get-Queue with actionFilter parameter' {
         Mock Invoke-RestMethod { return @{
               value=@{
                  pool=@{}
               }
            }}

         it 'Should return all the queues' {
            Get-Queue -projectName project -actionFilter 'None'

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq 'https://test.visualstudio.com/project/_apis/distributedtask/queues?api-version=3.0-preview.1&actionFilter=None'
            }
         }
      }

      Context 'Get-Queue with actionFilter & queueName parameter' {
         Mock Invoke-RestMethod { return @{
               value=@{
                  pool=@{}
               }
            }}

         it 'Should return all the queues' {
            Get-Queue -projectName project -actionFilter 'None' -queueName 'Hosted'

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq 'https://test.visualstudio.com/project/_apis/distributedtask/queues?api-version=3.0-preview.1&queueName=Hosted&actionFilter=None'
            }
         }
      }

      Context 'Get-Queue' {
         Mock Invoke-RestMethod { return @{
               pool=@{}
            }}

         It 'should return requested queue' {
            Get-Queue -projectName project -queueId 3

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq 'https://test.visualstudio.com/project/_apis/distributedtask/queues/3?api-version=3.0-preview.1'
            }
         }
      }
   }
}