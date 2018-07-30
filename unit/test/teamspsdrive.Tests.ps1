Set-StrictMode -Version Latest

Get-Module VSTeam | Remove-Module -Force

Import-Module $PSScriptRoot\..\..\VSTeam.psd1 -Force

Describe 'VSTeam Classes' {
   Context 'VSTeamUser ToString' {
      $obj = [PSCustomObject]@{
         displayName = 'Test User'
         id          = '1'
         uniqueName  = 'test@email.com'
      }

      $target = [VSTeamUser]::new($obj, 'Test Project')

      It 'should return displayname' {
         $target.ToString() | Should Be 'Test User'
      }
   }

   Context 'VSTeamProject ToString' {
      $obj = @{
         name        = 'Test Project'
         id          = 1
         description = ''
         url         = ''
         state       = ''
         revision    = ''
         visibility  = ''
      }

      $target = [VSTeamProject]::new($obj)

      It 'should return name' {
         $target.ToString() | Should Be 'Test Project'
      }
   }
}

Describe 'TeamsPSDrive' {
   Context 'VSTeamAccount & Projects' {
      Mock Get-VSTeamProject { return [VSTeamProject]::new([PSCustomObject]@{
               name        = 'TestProject'
               description = ''
               url         = ''
               id          = '123-5464-dee43'
               state       = ''
               visibility  = ''
               revision    = 0
               defaultTeam = [PSCustomObject]@{}
               _links      = [PSCustomObject]@{}
            }
         )
      }

      Mock Get-VSTeamPool {
         return [PSCustomObject]@{
            name                 = 'Default'
            id                   = 1
            size                 = 1
            createdBy            = [PSCustomObject]@{}
            administratorsGroup  = [PSCustomObject]@{}
            serviceAccountsGroup = [PSCustomObject]@{}
         }
      }

      $account = [VSTeamAccount]::new('TestAccount')

      It 'Should create VSTeamAccount' {
         $account | Should Not Be $null
      }

      # Skip 0 because that will be Agent Pools
      $project = $account.GetChildItem()[1]

      It 'Should return projects' {
         $project | Should Not Be $null
      }

      $actual = $project.GetChildItem()

      It 'Should return builds, releases, repositories and teams' {
         $actual | Should Not Be $null
         $actual[0].Name | Should Be 'Builds'
         $actual[0].ProjectName | Should Be 'TestProject'
         $actual[1].Name | Should Be 'Releases'
         $actual[1].ProjectName | Should Be 'TestProject'
         $actual[2].Name | Should Be 'Repositories'
         $actual[2].ProjectName | Should Be 'TestProject'
         $actual[3].Name | Should Be 'Teams'
         $actual[3].ProjectName | Should Be 'TestProject'
      }
   }

   Context 'Agent Pools' {
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
               _links             = [PSCustomObject]@{}
               createdOn          = '2018-03-28T16:48:58.317Z'
               maxParallelism     = 1
               id                 = 102
               status             = 'Online'
               version            = '1.336.1'
               osDescription      = 'Linux'
               name               = 'Test_Agent'
               systemCapabilities = [PSCustomObject]@{}
            }
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

   Context 'Builds' {
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

      It 'Should create Builds' {
         $builds | Should Not Be $null
      }

      $build = $builds.GetChildItem()

      It 'Should return build' {
         $build | Should Not Be $null
      }
   }

   Context 'Releases' {
      Mock Get-VSTeamRelease { return [PSCustomObject]@{
            id                = 1
            name              = 'Release-007'
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

   Context 'Repositories' {
      Mock Get-VSTeamGitRepository { return [VSTeamGitRepository]::new(@{
               id            = "fa7b6ac1-0d4c-46cb-8565-8fd49e2031ad"
               name          = ''
               url           = ''
               defaultBranch = ''
               size          = ''
               remoteUrl     = ''
               sshUrl        = ''
               project       = [PSCustomObject]@{
                  name        = 'TestProject'
                  description = ''
                  url         = ''
                  id          = '123-5464-dee43'
                  state       = ''
                  visibility  = ''
                  revision    = 0
                  defaultTeam = [PSCustomObject]@{}
                  _links      = [PSCustomObject]@{}
               }
            }, 'TestProject')
      }

      Mock Get-VSTeamGitRef { return [VSTeamRef]::new([PSCustomObject]@{
               objectId = '6f365a7143e492e911c341451a734401bcacadfd'
               name     = 'refs/heads/master'
               creator  = [PSCustomObject]@{
                  displayName = 'Microsoft.VisualStudio.Services.TFS'
                  id          = '1'
                  uniqueName  = 'some@email.com'
               }
            }, 'TestProject')
      }

      $repositories = [VSTeamRepositories]::new('Repositories', 'TestProject')

      It 'Should create Repositories' {
         $repositories | Should Not Be $null
      }

      $repository = $repositories.GetChildItem()[0]

      It 'Should return repository' {
         $repository | Should Not Be $null
      }

      $ref = $repository.GetChildItem()[0]

      It 'Should return ref' {
         $ref | Should Not Be $null
      }
   }

   Context 'Teams' {
      Mock Get-VSTeam { return [VSTeamTeam]::new(@{
               name        = ''
               ProjectName = ''
               description = ''
               id          = 1
            }, 'TestProject') }

      $teams = [VSTeamTeams]::new('Teams', 'TestProject')

      It 'Should create Teams' {
         $teams | Should Not Be $null
      }

      $team = $teams.GetChildItem()[0]

      It 'Should return team' {
         $team | Should Not Be $null
      }
   }
}