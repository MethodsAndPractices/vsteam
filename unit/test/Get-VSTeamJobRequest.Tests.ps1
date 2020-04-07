Set-StrictMode -Version Latest
$env:Testing=$true
# Loading the code from source files will break if functionality moves from one file to another, instead
# the InModuleScope command allows you to perform white-box unit testing on the
# internal \(non-exported\) code of a Script Module, ensuring the module is loaded.

InModuleScope Vsteam {

   Describe "Get-VSTeamJobRequest" {
      $resultsAzD = Get-Content "$PSScriptRoot/sampleFiles/jobrequestsAzD.json" -Raw | ConvertFrom-Json
      $results2017 = Get-Content "$PSScriptRoot/sampleFiles/jobrequests2017.json" -Raw | ConvertFrom-Json

      Context "2017" {
         # Set the account to use for testing. A normal user would do this
         # using the Set-VSTeamAccount function.
         Remove-VSTeamAccount
         Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' } -Verifiable

         Mock Invoke-RestMethod {
            # If this test fails uncomment the line below to see how the mock was called.
            # Write-Host $args

            return $results2017
         }

         It "return all jobs" {
            # This should stop the call to cache projects
            [VSTeamProjectCache]::timestamp = -1

            Get-VSTeamJobRequest -PoolId 5 -AgentID 4

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -like "*http://localhost:8080/tfs/defaultcollection/_apis/distributedtask/pools/5/jobrequests*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::DistributedTask)*" -and
               $Uri -like "*agentid=4*"
            }
         }

         It "return 2 jobs" {
            # This should stop the call to cache projects
            [VSTeamProjectCache]::timestamp = -1

            Get-VSTeamJobRequest -PoolId 5 -AgentID 4 -completedRequestCount 2

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -like "*http://localhost:8080/tfs/defaultcollection/_apis/distributedtask/pools/5/jobrequests*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::DistributedTask)*" -and
               $Uri -like "*agentid=4*" -and
               $Uri -like "*completedRequestCount=2*"
            }
         }
      }

      Context "AzD" {
         # Set the account to use for testing. A normal user would do this
         # using the Set-VSTeamAccount function.
         Remove-VSTeamAccount
         Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable

         Mock Invoke-RestMethod {
            # If this test fails uncomment the line below to see how the mock was called.
            # Write-Host $args

            return $resultsAzD
         }

         It "return all jobs" {
            # This should stop the call to cache projects
            [VSTeamProjectCache]::timestamp = -1

            Get-VSTeamJobRequest -PoolId 5 -AgentID 4

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -like "*https://dev.azure.com/test/_apis/distributedtask/pools/5/jobrequests*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::DistributedTask)*" -and
               $Uri -like "*agentid=4*"
            }
         }

         It "return 2 jobs" {
            # This should stop the call to cache projects
            [VSTeamProjectCache]::timestamp = -1

            Get-VSTeamJobRequest -PoolId 5 -AgentID 4 -completedRequestCount 2

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -like "*https://dev.azure.com/test/_apis/distributedtask/pools/5/jobrequests*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::DistributedTask)*" -and
               $Uri -like "*agentid=4*" -and
               $Uri -like "*completedRequestCount=2*"
            }
         }
      }
   }
}