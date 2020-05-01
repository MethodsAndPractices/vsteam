Set-StrictMode -Version Latest

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/$sut"

Describe 'Update-VSTeamAgent' {
   Mock _getInstance { return 'https://dev.azure.com/test' }
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
            $Uri -like "*api-version=$(_getApiVersion DistributedTask)*" -and
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