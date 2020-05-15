Set-StrictMode -Version Latest

Describe 'VSTeamAgent' {
   BeforeAll {
      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")
   
      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProjectCache.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectValidateAttribute.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"
   
      Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable
      [VSTeamVersions]::DistributedTask = '1.0-unitTest'

      # Mock the call to Get-Projects by the dynamic parameter for ProjectName
      Mock Invoke-RestMethod { return @() } -ParameterFilter {
         $Uri -like "*_apis/projects*"
      }
   }

   Context 'Remove-VSTeamAgent by ID' {
      BeforeAll {
         Mock Invoke-RestMethod
      }

      It 'should remove the agent with passed in Id' {
         Remove-VSTeamAgent -Pool 36 -Id 950 -Force

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Delete' -and
            $Uri -eq "https://dev.azure.com/test/_apis/distributedtask/pools/36/agents/950?api-version=$(_getApiVersion DistributedTask)"
         }
      }
   }

   Context 'Remove-VSTeamAgent throws' {
      BeforeAll {
         Mock Invoke-RestMethod { throw 'boom' }
      }

      It 'should remove the agent with passed in Id' {
         { Remove-VSTeamAgent -Pool 36 -Id 950 -Force } | Should -Throw
      }
   }
}

