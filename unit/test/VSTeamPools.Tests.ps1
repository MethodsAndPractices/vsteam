Set-StrictMode -Version Latest

#region include
Import-Module SHiPS

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamLeaf.ps1"
. "$here/../../Source/Classes/VSTeamDirectory.ps1"
. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Classes/VSTeamUserEntitlement.ps1"
. "$here/../../Source/Classes/VSTeamAgent.ps1"
. "$here/../../Source/Classes/VSTeamPool.ps1"
. "$here/../../Source/Private/applyTypes.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/Get-VSTeamAgent.ps1"
. "$here/../../Source/Public/Get-VSTeamPool.ps1"
. "$here/../../Source/Classes/$sut"
#endregion

Describe "VSTeamPools" {
   Context 'Constructor' {
      Mock Get-VSTeamPool { return [VSTeamPool]::new(@{
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

      It 'Should create Agent Pools' {
         $target | Should Not Be $null
      }

      $pool = $target.GetChildItem()[0]

      It 'Should return pool' {
         $pool | Should Not Be $null
      }

      $agent = $pool.GetChildItem()[0]

      It 'Should return agent' {
         $agent | Should Not Be $null
      }
   }      
}