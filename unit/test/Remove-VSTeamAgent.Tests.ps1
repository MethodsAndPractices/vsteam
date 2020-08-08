Set-StrictMode -Version Latest

Describe 'VSTeamAgent' {
   BeforeAll {
      Add-Type -Path "$PSScriptRoot/../../dist/bin/vsteam-lib.dll"
      
      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")
   
      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"

      # Prime the project cache with an empty list. This will make sure
      # any project name used will pass validation and Get-VSTeamProject 
      # will not need to be called.
      [vsteam_lib.ProjectCache]::Update([string[]]@())
   
      Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable
      [VSTeamVersions]::DistributedTaskReleased = '1.0-unitTest'
   }

   Context 'Remove-VSTeamAgent by ID' {
      BeforeAll {
         Mock Invoke-RestMethod
      }

      It 'should remove the agent with passed in Id' {
         Remove-VSTeamAgent -Pool 36 -Id 950 -Force

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Delete' -and
            $Uri -eq "https://dev.azure.com/test/_apis/distributedtask/pools/36/agents/950?api-version=$(_getApiVersion DistributedTaskReleased)"
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

