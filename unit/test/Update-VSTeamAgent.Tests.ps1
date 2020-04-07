Set-StrictMode -Version Latest
$env:Testing=$true
# Loading the code from source files will break if functionality moves from one file to another, instead
# the InModuleScope command allows you to perform white-box unit testing on the
# internal \(non-exported\) code of a Script Module, ensuring the module is loaded.

InModuleScope VSTeam {
   Describe 'Update-VSTeamAgent' {
      Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable
      [VSTeamVersions]::DistributedTask = '1.0-unitTest'

      Context 'Update-VSTeamAgent by ID' {
         Mock Invoke-RestMethod {
            # If this test fails uncomment the line below to see how the mock was called.
            # Write-Host $args
         }

         It 'should update the agent with passed in Id' {
            Update-VSTeamAgent -Pool 36 -Id 950 -Force

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Method -eq 'Post' -and
               $Uri -like "*https://dev.azure.com/test/_apis/distributedtask/pools/36/messages*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::DistributedTask)*" -and
               $Uri -like "*agentId=950*"
            }
         }
      }

      Context 'Update-VSTeamAgent throws' {
         Mock Invoke-RestMethod { throw 'boom' }

         It 'should update the agent with passed in Id' {
            { Update-VSTeamAgent -Pool 36 -Id 950 -Force } | Should Throw
         }
      }
   }
}