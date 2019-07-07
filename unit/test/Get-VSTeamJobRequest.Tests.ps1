Import-Module SHiPS

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Classes/VSTeamLeaf.ps1"
. "$here/../../Source/Classes/VSTeamJobRequest.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/$sut"

$resultsAzD = Get-Content "$PSScriptRoot/sampleFiles/jobrequestsAzD.json" -Raw | ConvertFrom-Json
$results2017 = Get-Content "$PSScriptRoot/sampleFiles/jobrequests2017.json" -Raw | ConvertFrom-Json

Describe "Get-VSTeamJobRequest" {
   Context "2017" {
      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      [VSTeamVersions]::Account = 'http://localhost:8080/tfs/defaultcollection'
      Mock Invoke-RestMethod {
         # If this test fails uncomment the line below to see how the mock was called.
         # Write-Host $args
         
         return $results2017
      }

      It "return all jobs" {
         # This should stop the call to cache projects
         [VSTeamProjectCache]::timestamp = (Get-Date).Minute

         Get-VSTeamJobRequest -PoolId 5 -AgentID 4

         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -like "*http://localhost:8080/tfs/defaultcollection/_apis/distributedtask/pools/5/jobrequests/*" -and
            $Uri -like "*api-version=$([VSTeamVersions]::DistributedTask)*" -and
            $Uri -like "*agentid=4*" 
         }
      }

      It "return 2 jobs" {
         # This should stop the call to cache projects
         [VSTeamProjectCache]::timestamp = (Get-Date).Minute

         Get-VSTeamJobRequest -PoolId 5 -AgentID 4 -completedRequestCount 2

         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -like "*http://localhost:8080/tfs/defaultcollection/_apis/distributedtask/pools/5/jobrequests/*" -and
            $Uri -like "*api-version=$([VSTeamVersions]::DistributedTask)*" -and
            $Uri -like "*agentid=4*" -and
            $Uri -like "*completedRequestCount=2*"
         }
      }
   }

   Context "AzD" {
      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      [VSTeamVersions]::Account = 'https://dev.azure.com/test'
      Mock Invoke-RestMethod {
         # If this test fails uncomment the line below to see how the mock was called.
         #Write-Host $args
         
         return $resultsAzD
      }

      It "return all jobs" {
         # This should stop the call to cache projects
         [VSTeamProjectCache]::timestamp = (Get-Date).Minute

         Get-VSTeamJobRequest -PoolId 5 -AgentID 4

         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -like "*https://dev.azure.com/test/_apis/distributedtask/pools/5/jobrequests/*" -and
            $Uri -like "*api-version=$([VSTeamVersions]::DistributedTask)*" -and
            $Uri -like "*agentid=4*" 
         }
      }

      It "return 2 jobs" {
         # This should stop the call to cache projects
         [VSTeamProjectCache]::timestamp = (Get-Date).Minute
      
         Get-VSTeamJobRequest -PoolId 5 -AgentID 4 -completedRequestCount 2

         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -like "*https://dev.azure.com/test/_apis/distributedtask/pools/5/jobrequests/*" -and
            $Uri -like "*api-version=$([VSTeamVersions]::DistributedTask)*" -and
            $Uri -like "*agentid=4*" -and
            $Uri -like "*completedRequestCount=2*"
         }
      }
   }
}