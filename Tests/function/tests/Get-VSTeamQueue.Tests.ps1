Set-StrictMode -Version Latest

Describe 'VSTeamQueue' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      ## Arrange
      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'DistributedTask' }
      Mock Invoke-RestMethod { Open-SampleFile 'Get-VSTeamQueue.json' }
      Mock Invoke-RestMethod { Open-SampleFile 'Get-VSTeamQueue.json' -Index 0 } -ParameterFilter { $Uri -like "*101*" }
   }

   Context 'Get-VSTeamQueue' {
      It 'should return requested queue' {
         ## Act
         $queue = Get-VSTeamQueue -projectName project -queueId 101

         ## Assert
         $queue.Name | Should -Be 'Default' -Because 'Name should be set'

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/project/_apis/distributedtask/queues/101?api-version=$(_getApiVersion DistributedTask)"
         }
      }

      it 'should return all the queues with actionFilter & queueName parameter' {
         ## Act
         Get-VSTeamQueue -projectName project -actionFilter 'None' -queueName 'Hosted'

         # With PowerShell core the order of the query string is not the
         # same from run to run!  So instead of testing the entire string
         # matches I have to search for the portions I expect but can't
         # assume the order.
         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -like "*https://dev.azure.com/test/project/_apis/distributedtask/queues*" -and
            $Uri -like "*api-version=$(_getApiVersion DistributedTask)*" -and
            $Uri -like "*actionFilter=None*" -and
            $Uri -like "*queueName=Hosted*"
         }
      }

      it 'should return all the queues with no parameters' {
         ## Act
         $queues = Get-VSTeamQueue -ProjectName project

         ## Assert
         $queues.Count | Should -Be 11

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/project/_apis/distributedtask/queues?api-version=$(_getApiVersion DistributedTask)"
         }
      }

      it 'should return all the queues with queueName parameter' {
         ## Act
         Get-VSTeamQueue -projectName project -queueName 'Hosted'

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/project/_apis/distributedtask/queues?api-version=$(_getApiVersion DistributedTask)&queueName=Hosted"
         }
      }

      it 'should return all the queues with actionFilter parameter' {
         ## Act
         Get-VSTeamQueue -projectName project -actionFilter 'None'

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/project/_apis/distributedtask/queues?api-version=$(_getApiVersion DistributedTask)&actionFilter=None"
         }
      }
   }
}