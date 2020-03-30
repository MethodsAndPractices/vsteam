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
. "$here/../../Source/Classes/VSTeamTask.ps1"
. "$here/../../Source/Classes/VSTeamAttempt.ps1"
. "$here/../../Source/Classes/VSTeamEnvironment.ps1"
. "$here/../../Source/Classes/VSTeamRelease.ps1"
. "$here/../../Source/Private/applyTypes.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/Get-VSTeamRelease.ps1"
. "$here/../../Source/Classes/$sut"
#endregion

Describe "VSTeamReleases" {
   Context 'Constructor' {
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

      It 'Should create Releases directory' {
         $releases | Should Not Be $null
      }

      It 'Should be named Releases' {
         $releases.Name | Should Be 'Releases'
      }

      $release = $releases.GetChildItem()[0]

      It 'Should return releases' {
         $release | Should Not Be $null
      }

      $env = $release.GetChildItem()[0]

      It 'Should return environments' {
         $env | Should Not Be $null
      }

      $attempt = $env.GetChildItem()[0]

      It 'Should return attempts' {
         $attempt | Should Not Be $null
      }

      $task = $attempt.GetChildItem()[0]

      It 'Should return tasks' {
         $task | Should Not Be $null
      }
   }
}