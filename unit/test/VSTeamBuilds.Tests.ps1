Set-StrictMode -Version Latest

Describe "VSTeamBuilds" {
   BeforeAll {
      Import-Module SHiPS

      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

      . "$PSScriptRoot/../../Source/Classes/VSTeamLeaf.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamDirectory.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProjectCache.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectCompleter.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectValidateAttribute.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamUserEntitlement.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamBuild.ps1"
      . "$PSScriptRoot/../../Source/Private/applyTypes.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamBuild.ps1"
      . "$PSScriptRoot/../../Source/Classes/$sut"
   }

   Context "Constructor" {
      BeforeAll {
         Mock Get-VSTeamBuild { return @([PSCustomObject]@{
                  id            = 1
                  description   = ''
                  buildNumber   = '1'
                  status        = 'completed'
                  result        = 'succeeded'
                  startTime     = Get-Date
                  lastChangedBy = [PSCustomObject]@{
                     id          = ''
                     displayName = 'Test User'
                     uniqueName  = 'test@email.com'
                  }
                  requestedBy   = [PSCustomObject]@{
                     id          = ''
                     displayName = 'Test User'
                     uniqueName  = 'test@email.com'
                  }
                  requestedFor  = [PSCustomObject]@{
                     id          = ''
                     displayName = 'Test User'
                     uniqueName  = 'test@email.com'
                  }
                  definition    = [PSCustomObject]@{
                     name     = 'Test CI'
                     fullname = 'Test CI'
                  }
                  project       = [PSCustomObject]@{
                     name = 'Test Project'
                  }
               }
            )
         }

         $builds = [VSTeamBuilds]::new('TestBuild', 'TestProject')
         $build = $builds.GetChildItem()
      }

      It 'Should create Builds' {
         $builds | Should -Not -Be $null
      }

      It 'Should return build' {
         $build | Should -Not -Be $null
      }
   }
}