Set-StrictMode -Version Latest

Describe "VSTeamAccount" {
   BeforeAll {
      Import-Module SHiPS

      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

      . "$PSScriptRoot/../../Source/Classes/VSTeamLeaf.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamDirectory.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProjectCache.ps1"
      . "$PSScriptRoot/../../Source/Classes/UncachedProjectCompleter.ps1"
      . "$PSScriptRoot/../../Source/Classes/UncachedProjectValidateAttribute.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamBuildDefinitionProcessPhaseStep.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamBuildDefinitionProcessPhase.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamBuildDefinitionProcess.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamUserEntitlement.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamPool.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamPools.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamExtensions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamQueue.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamQueues.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamRepositories.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamTeams.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamReleaseDefinitions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamBuild.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamBuilds.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamTask.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamAttempt.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamEnvironment.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamRelease.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamReleases.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamBuildDefinitions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamFeeds.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamGroups.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamUsers.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamPermissions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProject.ps1"
      . "$PSScriptRoot/../../Source/Private/applyTypes.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamPool.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamProject.ps1"
      . "$PSScriptRoot/../../Source/Classes/$sut"
   }

   Context 'Constructor' {
      BeforeAll {
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

         # Skip 0 because that will be Agent Pools
         # Skip 1 because that will be Extensions
         # Skip 2 because that will be Feeds
         # Skip 3 because that will be Permissions
         $project = $account.GetChildItem()[4]

         $actual = $project.GetChildItem()
      }

      It 'Should create VSTeamAccount' {
         $account | Should -Not -Be $null
      }

      It 'Should return projects' {
         $project | Should -Not -Be $null
      }

      It 'Should return builds, releases, repositories and teams' {
         $actual | Should -Not -Be $null
         $actual[0].Name | Should -Be 'Build Definitions'
         $actual[0].ProjectName | Should -Be 'TestProject'
         $actual[1].Name | Should -Be 'Builds'
         $actual[1].ProjectName | Should -Be 'TestProject'
         $actual[2].Name | Should -Be 'Queues'
         $actual[2].ProjectName | Should -Be 'TestProject'
         $actual[3].Name | Should -Be 'Release Definitions'
         $actual[3].ProjectName | Should -Be 'TestProject'
         $actual[4].Name | Should -Be 'Releases'
         $actual[4].ProjectName | Should -Be 'TestProject'
         $actual[5].Name | Should -Be 'Repositories'
         $actual[5].ProjectName | Should -Be 'TestProject'
         $actual[6].Name | Should -Be 'Teams'
         $actual[6].ProjectName | Should -Be 'TestProject'
      }
   }
}