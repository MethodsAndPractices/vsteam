Set-StrictMode -Version Latest

Describe 'VSTeamAgent' {
   BeforeAll {
      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")
      
      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProjectCache.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectCompleter.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectValidateAttribute.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"
      
      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '1.0-unittest' } -ParameterFilter { $Service -eq 'DistributedTask' }
   }

   Context 'Update-VSTeamAgent by ID' {
      BeforeAll {
         Mock Invoke-RestMethod
      }

      It 'should update the agent with passed in Id' {
         Update-VSTeamAgent -Pool 36 -Id 950 -Force

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Post' -and
            $Uri -like "*https://dev.azure.com/test/_apis/distributedtask/pools/36/messages*" -and
            $Uri -like "*api-version=$(_getApiVersion DistributedTask)*" -and
            $Uri -like "*agentId=950*"
         }
      }
   }

   Context 'Update-VSTeamAgent throws' {
      BeforeAll {
         Mock Invoke-RestMethod { throw 'boom' }
      }

      It 'should update the agent with passed in Id' {
         { Update-VSTeamAgent -Pool 36 -Id 950 -Force } | Should -Throw
      }
   }
}