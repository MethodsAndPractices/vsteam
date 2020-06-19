Set-StrictMode -Version Latest

BeforeAll {
   Import-Module SHiPS

   $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

   . "$PSScriptRoot/../../Source/Classes/VSTeamDirectory.ps1"
   . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
   . "$PSScriptRoot/../../Source/Classes/VSTeamProjectCache.ps1"
   . "$PSScriptRoot/../../Source/Classes/ProjectCompleter.ps1"
   . "$PSScriptRoot/../../Source/Classes/ProjectValidateAttribute.ps1"
   . "$PSScriptRoot/../../Source/Classes/VSTeamAgent.ps1"
   . "$PSScriptRoot/../../Source/Private/common.ps1"
   . "$PSScriptRoot/../../Source/Public/Set-VSTeamDefaultProject.ps1"
   . "$PSScriptRoot/../../Source/Public/$sut"
}

Describe 'VSTeamAgent' {
   BeforeAll {
      ## Arrange
      # Make sure the project name is valid. By returning an empty array
      # all project names are valid. Otherwise, you name you pass for the
      # project in your commands must appear in the list.
      Mock _getProjects { return @() }
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'DistributedTask' }

      $testAgent = Get-Content "$PSScriptRoot\sampleFiles\agentSingleResult.json" -Raw | ConvertFrom-Json

      Mock _getInstance { return 'https://dev.azure.com/test' }

      # Mock the call to Get-Projects by the dynamic parameter for ProjectName
      Mock Invoke-RestMethod { return @() } -ParameterFilter { $Uri -like "*_apis/projects*" }

      # Even with a default set this URI should not have the project added.
      Set-VSTeamDefaultProject -Project Testing
   }

   Context 'Get-VSTeamAgent' {
      BeforeAll {
         Mock Invoke-RestMethod { return [PSCustomObject]@{
               count = 1
               value = $testAgent
            }
         }

         Mock Invoke-RestMethod { return $testAgent } -ParameterFilter { $Uri -like "*101*" }
      }

      it 'by pool id should return all the agents' {
         ## Act
         Get-VSTeamAgent -PoolId 1

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/_apis/distributedtask/pools/1/agents?api-version=$(_getApiVersion DistributedTask)"
         }
      }

      it 'with agent id parameter should return on agent' {
         ## Act
         Get-VSTeamAgent -PoolId 1 -id 101

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/_apis/distributedtask/pools/1/agents/101?api-version=$(_getApiVersion DistributedTask)"
         }
      }

      it 'PoolID from pipeline by value should return all the agents' {
         ## Act
         1 | Get-VSTeamAgent

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/_apis/distributedtask/pools/1/agents?api-version=$(_getApiVersion DistributedTask)"
         }
      }
   }
}

