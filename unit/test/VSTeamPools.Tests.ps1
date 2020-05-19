Set-StrictMode -Version Latest

Describe "VSTeamPools" {
   BeforeAll {
      Import-Module SHiPS

      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

      . "$PSScriptRoot/../../Source/Classes/VSTeamLeaf.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamDirectory.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProjectCache.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamUserEntitlement.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamAgent.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamPool.ps1"
      . "$PSScriptRoot/../../Source/Private/applyTypes.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamAgent.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamPool.ps1"
      . "$PSScriptRoot/../../Source/Classes/$sut"
   }

   Context 'Constructor' {
      BeforeAll {
         Mock Get-VSTeamPool {
            return [VSTeamPool]::new(@{
                  owner     = [PSCustomObject]@{
                     displayName = 'Test User'
                     id          = '1'
                     uniqueName  = 'test@email.com'
                  }
                  createdBy = [PSCustomObject]@{
                     displayName = 'Test User'
                     id          = '1'
                     uniqueName  = 'test@email.com'
                  }
                  id        = 1
                  size      = 1
                  isHosted  = $false
                  Name      = 'Default'
               }
            )
         }

         Mock Get-VSTeamAgent { return [VSTeamAgent]::new(@{
                  _links             = [PSCustomObject]@{ }
                  createdOn          = '2018-03-28T16:48:58.317Z'
                  maxParallelism     = 1
                  id                 = 102
                  enabled            = $false
                  status             = 'Online'
                  version            = '1.336.1'
                  osDescription      = 'Linux'
                  name               = 'Test_Agent'
                  systemCapabilities = [PSCustomObject]@{ }
               }, 1
            )
         }

         $target = [VSTeamPools]::new('Agent Pools')
         $pool = $target.GetChildItem()[0]
         $agent = $pool.GetChildItem()[0]
      }

      It 'Should create Agent Pools' {
         $target | Should -Not -Be $null
      }

      It 'Should return pool' {
         $pool | Should -Not -Be $null
      }

      It 'Should return agent' {
         $agent | Should -Not -Be $null
      }
   }
}