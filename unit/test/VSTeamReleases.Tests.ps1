Set-StrictMode -Version Latest

Describe "VSTeamReleases" {
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
      . "$PSScriptRoot/../../Source/Classes/VSTeamTask.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamAttempt.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamEnvironment.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamRelease.ps1"
      . "$PSScriptRoot/../../Source/Private/applyTypes.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamRelease.ps1"
      . "$PSScriptRoot/../../Source/Classes/$sut"
   }

   Context 'Constructor' {
      BeforeAll {
         Mock Get-VSTeamRelease { return [PSCustomObject]@{
               id                = 1
               name              = 'Release - 007'
               status            = 'active'
               createdBy         = [PSCustomObject]@{
                  displayname = 'Test User'
                  uniqueName  = 'test@email.com'
                  id          = '1'
               }
               modifiedBy        = [PSCustomObject]@{
                  displayname = 'Test User'
                  uniqueName  = 'test@email.com'
                  id          = '1'
               }
               requestedFor      = [PSCustomObject]@{
                  displayname = ''
                  uniqueName  = ''
                  id          = ''
               }
               createdOn         = Get-Date
               releaseDefinition = [PSCustomObject]@{
                  name = 'Test Release Def'
               }
               environments      = @([PSCustomObject]@{
                     id          = 1
                     name        = 'Dev'
                     status      = 'Succeeded'
                     deploySteps = @([PSCustomObject]@{
                           id                  = 963
                           deploymentId        = 350
                           attempt             = 1
                           reason              = 'automated'
                           status              = 'succeeded'
                           releaseDeployPhases = @([PSCustomObject]@{
                                 deploymentJobs = @([PSCustomObject]@{
                                       tasks = @([PSCustomObject]@{
                                             name   = 'Initialize Job'
                                             status = 'succeeded'
                                             id     = 1
                                             logUrl = ''
                                          }
                                       )
                                    }
                                 )
                              }
                           )
                        }
                     )
                  }
               )
            }
         }

         $releases = [VSTeamReleases]::new('Releases', 'TestProject')
         $release = $releases.GetChildItem()[0]
         $env = $release.GetChildItem()[0]
         $attempt = $env.GetChildItem()[0]
         $task = $attempt.GetChildItem()[0]
      }

      It 'Should create Releases directory' {
         $releases | Should -Not -Be $null
      }

      It 'Should be named Releases' {
         $releases.Name | Should -Be 'Releases'
      }

      It 'Should return releases' {
         $release | Should -Not -Be $null
      }

      It 'Should return environments' {
         $env | Should -Not -Be $null
      }

      It 'Should return attempts' {
         $attempt | Should -Not -Be $null
      }

      It 'Should return tasks' {
         $task | Should -Not -Be $null
      }
   }
}