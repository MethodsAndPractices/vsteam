Set-StrictMode -Version Latest

#region include
Import-Module SHiPS

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamDirectory.ps1"
. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Classes/VSTeamAgent.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/Get-VSTeamAgent.ps1"
. "$here/../../Source/Public/$sut"
#endregion

Describe 'VSTeamPool' {
   ## Arrange
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

   [VSTeamVersions]::DistributedTask = '1.0-unitTest'

   Mock _getInstance { return 'https://dev.azure.com/test' }
   
   Mock Invoke-RestMethod { return $testAgent }
   
   Context 'Get-VSTeamPool' {
      it 'with id parameter should return all the pools' {
         ## Act
         Get-VSTeamAgent -PoolId 1 -id 1

         ## Assert
         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/_apis/distributedtask/pools/1/agents/1?api-version=$([VSTeamVersions]::DistributedTask)"
         }
      }
   }
}