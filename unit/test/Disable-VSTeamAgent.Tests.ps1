Set-StrictMode -Version Latest

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/$sut"

Describe 'VSTeamAgent' {
   Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable
   [VSTeamVersions]::DistributedTask = '1.0-unitTest'
   
   # Mock the call to Get-Projects by the dynamic parameter for ProjectName
   Mock Invoke-RestMethod { return @() } -ParameterFilter {
      $Uri -like "*_apis/projects*"
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