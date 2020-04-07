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
. "$here/../../Source/Public/Set-VSTeamDefaultProject.ps1"
. "$here/../../Source/Public/$sut"
#endregion

Describe 'VSTeamAgent' {
   ## Arrange
   Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'DistributedTask' }

   $testAgent = Get-Content "$PSScriptRoot\sampleFiles\agentSingleResult.json" -Raw | ConvertFrom-Json

   Mock _getInstance { return 'https://dev.azure.com/test' }
   
   # Mock the call to Get-Projects by the dynamic parameter for ProjectName
   Mock Invoke-RestMethod { return @() } -ParameterFilter { $Uri -like "*_apis/projects*" }

   # Even with a default set this URI should not have the project added. 
   Set-VSTeamDefaultProject -Project Testing

   Context 'Get-VSTeamAgent' {
      Mock Invoke-RestMethod { return [PSCustomObject]@{
            count = 1
            value = $testAgent
         }
      }   
      Mock Invoke-RestMethod { return $testAgent } -ParameterFilter { $Uri -like "*101*"}   

      it 'by pool id should return all the agents' {
         ## Act
         Get-VSTeamAgent -PoolId 1

         ## Assert
         Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/_apis/distributedtask/pools/1/agents?api-version=$(_getApiVersion DistributedTask)"
         }
      }

      it 'with agent id parameter should return on agent' {
         ## Act
         Get-VSTeamAgent -PoolId 1 -id 101

         ## Assert
         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/_apis/distributedtask/pools/1/agents/101?api-version=$(_getApiVersion DistributedTask)"
         }
      }

      it 'PoolID from pipeline by value should return all the agents' {
         ## Act
         1 | Get-VSTeamAgent

         ## Assert
         Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/_apis/distributedtask/pools/1/agents?api-version=$(_getApiVersion DistributedTask)"
         }
      }
   }
}