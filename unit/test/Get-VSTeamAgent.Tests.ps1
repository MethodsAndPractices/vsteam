Set-StrictMode -Version Latest

Import-Module SHiPS

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamDirectory.ps1"
. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Classes/VSTeamAgent.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/$sut"

$testAgent = [PSCustomObject]@{
   _links             = [PSCustomObject]@{ }
   createdOn          = '2018-03-28T16:48:58.317Z'
   maxParallelism     = 1
   id                 = 102
   status             = 'Online'
   version            = '1.336.1'
   enabled            = $true
   osDescription      = 'Linux'
   name               = 'Test_Agent'
   authorization      = [PSCustomObject]@{ }
   systemCapabilities = [PSCustomObject]@{ }
}

Describe 'Get-VSTeamAgent' {
   Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable
   [VSTeamVersions]::DistributedTask = '1.0-unitTest'
   
   # Mock the call to Get-Projects by the dynamic parameter for ProjectName
   Mock Invoke-RestMethod { return @() } -ParameterFilter {
      $Uri -like "*_apis/projects*"
   }

   Context 'Get-VSTeamAgent' {
      Mock Invoke-RestMethod { return [PSCustomObject]@{
            count = 1
            value = $testAgent
         }
      }

      it 'Should return all the pools' {
         Get-VSTeamAgent -PoolId 1

         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/_apis/distributedtask/pools/1/agents?api-version=$([VSTeamVersions]::DistributedTask)"
         }
      }
   }

   Context 'Get-VSTeamAgent PoolID from pipeline by value' {
      Mock Invoke-RestMethod { return [PSCustomObject]@{
            count = 1
            value = $testAgent
         }
      }

      it 'Should return all the pools' {
         1 | Get-VSTeamAgent

         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/_apis/distributedtask/pools/1/agents?api-version=$([VSTeamVersions]::DistributedTask)"
         }
      }
   }
}