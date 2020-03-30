Set-StrictMode -Version Latest

InModuleScope VSTeam {
   Describe 'TeamsPSDrive' {
      # Mock the call to Get-Projects by the dynamic parameter for ProjectName
      Mock Invoke-RestMethod { return @() } -ParameterFilter {
         $Uri -like "*_apis/projects*"
      }

      Context 'VSTeamAccount & Projects' {
         Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Graph' -or $Service -eq 'Packaging' }
         Mock Get-VSTeamProject { return [VSTeamProject]::new([PSCustomObject]@{
                  name        = 'TestProject'
                  description = ''
                  url         = ''
                  id          = '123 - 5464-dee43'
                  state       = ''
                  visibility  = ''
                  revision    = 0
                  defaultTeam = [PSCustomObject]@{ }
                  _links      = [PSCustomObject]@{ }
               }
            )
         }

         Mock Get-VSTeamPool {
            return [PSCustomObject]@{
               name                 = 'Default'
               id                   = 1
               size                 = 1
               createdBy            = [PSCustomObject]@{ }
               administratorsGroup  = [PSCustomObject]@{ }
               serviceAccountsGroup = [PSCustomObject]@{ }
            }
         }

         $account = [VSTeamAccount]::new('TestAccount')

         It 'Should create VSTeamAccount' {
            $account | Should Not Be $null
         }

         # Skip 0 because that will be Agent Pools
         # Skip 1 because that will be Extensions
         # Skip 2 because that will be Feeds
         # Skip 3 because that will be Permissions
         $project = $account.GetChildItem()[4]

         It 'Should return projects' {
            $project | Should Not Be $null
         }

         $actual = $project.GetChildItem()

         It 'Should return builds, releases, repositories and teams' {
            $actual | Should Not Be $null
            $actual[0].Name | Should Be 'Build Definitions'
            $actual[0].ProjectName | Should Be 'TestProject'
            $actual[1].Name | Should Be 'Builds'
            $actual[1].ProjectName | Should Be 'TestProject'
            $actual[2].Name | Should Be 'Queues'
            $actual[2].ProjectName | Should Be 'TestProject'
            $actual[3].Name | Should Be 'Release Definitions'
            $actual[3].ProjectName | Should Be 'TestProject'
            $actual[4].Name | Should Be 'Releases'
            $actual[4].ProjectName | Should Be 'TestProject'
            $actual[5].Name | Should Be 'Repositories'
            $actual[5].ProjectName | Should Be 'TestProject'
            $actual[6].Name | Should Be 'Teams'
            $actual[6].ProjectName | Should Be 'TestProject'
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

      Context 'Feeds' {
         $feedResults = Get-Content "$PSScriptRoot\sampleFiles\feeds.json" -Raw | ConvertFrom-Json
         $singleResult = $feedResults.value[0]

         Mock Get-VSTeamFeed {
            return [VSTeamFeed]::new($singleResult)
         }

         $target = [VSTeamFeeds]::new('Feeds')

         It 'Should create Feeds' {
            $target | Should Not Be $null
         }

         $feed = $target.GetChildItem()[0]

         It 'Should return feed' {
            $feed | Should Not Be $null
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
   }
}