Set-StrictMode -Version Latest

Describe "Get-VSTeamJobRequest" {
   BeforeAll {
      Import-Module SHiPS

      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProjectCache.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectValidateAttribute.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamLeaf.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamJobRequest.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"

      ## Arrange
      $resultsAzD = Get-Content "$PSScriptRoot/sampleFiles/jobrequestsAzD.json" -Raw | ConvertFrom-Json
      $results2017 = Get-Content "$PSScriptRoot/sampleFiles/jobrequests2017.json" -Raw | ConvertFrom-Json

      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'DistributedTask' }
   }

   Context "Server" {
      BeforeAll {
         ## Arrnage
         Mock Invoke-RestMethod { return $results2017 }
         Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' }
      }

      It "return all jobs" {
         ## Act
         Get-VSTeamJobRequest -PoolId 5 -AgentID 4

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -like "*http://localhost:8080/tfs/defaultcollection/_apis/distributedtask/pools/5/jobrequests*" -and
            $Uri -like "*api-version=$(_getApiVersion DistributedTask)*" -and
            $Uri -like "*agentid=4*"
         }
      }

      It "return 2 jobs" {
         # This should stop the call to cache projects
         Mock _hasProjectCacheExpired { return $false }

         Get-VSTeamJobRequest -PoolId 5 -AgentID 4 -completedRequestCount 2

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -like "*http://localhost:8080/tfs/defaultcollection/_apis/distributedtask/pools/5/jobrequests*" -and
            $Uri -like "*api-version=$(_getApiVersion DistributedTask)*" -and
            $Uri -like "*agentid=4*" -and
            $Uri -like "*completedRequestCount=2*"
         }
      }
   }

   Context "Services" {
      BeforeAll {
         Mock Invoke-RestMethod { return $resultsAzD }
         Mock _getInstance { return 'https://dev.azure.com/test' }
      }

      It "return all jobs" {
         # This should stop the call to cache projects
         Mock _hasProjectCacheExpired { return $false }

         Get-VSTeamJobRequest -PoolId 5 -AgentID 4

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -like "*https://dev.azure.com/test/_apis/distributedtask/pools/5/jobrequests*" -and
            $Uri -like "*api-version=$(_getApiVersion DistributedTask)*" -and
            $Uri -like "*agentid=4*"
         }
      }

      It "return 2 jobs" {
         # This should stop the call to cache projects
         Mock _hasProjectCacheExpired { return $false }

         Get-VSTeamJobRequest -PoolId 5 -AgentID 4 -completedRequestCount 2

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -like "*https://dev.azure.com/test/_apis/distributedtask/pools/5/jobrequests*" -and
            $Uri -like "*api-version=$(_getApiVersion DistributedTask)*" -and
            $Uri -like "*agentid=4*" -and
            $Uri -like "*completedRequestCount=2*"
         }
      }
   }
}