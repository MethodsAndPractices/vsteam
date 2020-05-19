Set-StrictMode -Version Latest

Describe 'VSTeamAgent' {
   BeforeAll {
      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProjectCache.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectValidateAttribute.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"
   }

   Context 'Enable-VSTeamAgent' {
      ## Arrnage
      BeforeAll {
         Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'DistributedTask' }

         Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable

         # Mock the call to Get-Projects by the dynamic parameter for ProjectName
         Mock Invoke-RestMethod -ParameterFilter { $Uri -like "*950*" }
         Mock Invoke-RestMethod { throw 'boom' } -ParameterFilter { $Uri -like "*101*" }
      }

      It 'by Id should enable the agent with passed in Id' {
         ## Act
         Enable-VSTeamAgent -Pool 36 -Id 950

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Method -eq 'Patch' -and
            $Uri -eq "https://dev.azure.com/test/_apis/distributedtask/pools/36/agents/950?api-version=$(_getApiVersion DistributedTask)"
         }
      }

      It 'should throw' {
         ## Act / ## Assert
         { Enable-VSTeamAgent -Pool 36 -Id 101 } | Should -Throw
      }
   }
}
