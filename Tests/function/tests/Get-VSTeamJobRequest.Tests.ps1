Set-StrictMode -Version Latest

Describe "Get-VSTeamJobRequest" {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      ## Arrange
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter {
         $Service -eq 'DistributedTaskReleased' 
      }
   }

   Context "Server" {
      BeforeAll {
         ## Arrnage
         Mock Invoke-RestMethod { Open-SampleFile 'jobrequests2017.json' }
         Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' }
      }

      It "should return all jobs" {
         ## Act
         Get-VSTeamJobRequest -PoolId 5 -AgentID 4

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -like "*http://localhost:8080/tfs/defaultcollection/_apis/distributedtask/pools/5/jobrequests*" -and
            $Uri -like "*api-version=$(_getApiVersion DistributedTaskReleased)*" -and
            $Uri -like "*agentid=4*"
         }
      }

      It "should return 2 jobs" {
         Get-VSTeamJobRequest -PoolId 5 -AgentID 4 -completedRequestCount 2

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -like "*http://localhost:8080/tfs/defaultcollection/_apis/distributedtask/pools/5/jobrequests*" -and
            $Uri -like "*api-version=$(_getApiVersion DistributedTaskReleased)*" -and
            $Uri -like "*agentid=4*" -and
            $Uri -like "*completedRequestCount=2*"
         }
      }
   }

   Context "Services" {
      BeforeAll {
         Mock Invoke-RestMethod { Open-SampleFile 'jobrequestsAzD.json' }
         Mock _getInstance { return 'https://dev.azure.com/test' }
      }

      It "should return all jobs" {
         Get-VSTeamJobRequest -PoolId 5 -AgentID 4

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -like "*https://dev.azure.com/test/_apis/distributedtask/pools/5/jobrequests*" -and
            $Uri -like "*api-version=$(_getApiVersion DistributedTaskReleased)*" -and
            $Uri -like "*agentid=4*"
         }
      }

      It "should return 2 jobs" {
         Get-VSTeamJobRequest -PoolId 5 -AgentID 4 -completedRequestCount 2

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -like "*https://dev.azure.com/test/_apis/distributedtask/pools/5/jobrequests*" -and
            $Uri -like "*api-version=$(_getApiVersion DistributedTaskReleased)*" -and
            $Uri -like "*agentid=4*" -and
            $Uri -like "*completedRequestCount=2*"
         }
      }
   }
}