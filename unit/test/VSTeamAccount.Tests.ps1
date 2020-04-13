Set-StrictMode -Version Latest

#region include
Import-Module SHiPS

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamLeaf.ps1"
. "$here/../../Source/Classes/VSTeamDirectory.ps1"
. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Classes/UncachedProjectCompleter.ps1"
. "$here/../../Source/Classes/UncachedProjectValidateAttribute.ps1"
. "$here/../../Source/Classes/VSTeamBuildDefinitionProcessPhaseStep.ps1"
. "$here/../../Source/Classes/VSTeamBuildDefinitionProcessPhase.ps1"
. "$here/../../Source/Classes/VSTeamBuildDefinitionProcess.ps1"
. "$here/../../Source/Classes/VSTeamUserEntitlement.ps1"
. "$here/../../Source/Classes/VSTeamPool.ps1"
. "$here/../../Source/Classes/VSTeamPools.ps1"
. "$here/../../Source/Classes/VSTeamExtensions.ps1"
. "$here/../../Source/Classes/VSTeamQueue.ps1"
. "$here/../../Source/Classes/VSTeamQueues.ps1"
. "$here/../../Source/Classes/VSTeamRepositories.ps1"
. "$here/../../Source/Classes/VSTeamTeams.ps1"
. "$here/../../Source/Classes/VSTeamReleaseDefinitions.ps1"
. "$here/../../Source/Classes/VSTeamBuild.ps1"
. "$here/../../Source/Classes/VSTeamBuilds.ps1"
. "$here/../../Source/Classes/VSTeamTask.ps1"
. "$here/../../Source/Classes/VSTeamAttempt.ps1"
. "$here/../../Source/Classes/VSTeamEnvironment.ps1"
. "$here/../../Source/Classes/VSTeamRelease.ps1"
. "$here/../../Source/Classes/VSTeamReleases.ps1"
. "$here/../../Source/Classes/VSTeamBuildDefinitions.ps1"
. "$here/../../Source/Classes/VSTeamFeeds.ps1"
. "$here/../../Source/Classes/VSTeamGroups.ps1"
. "$here/../../Source/Classes/VSTeamUsers.ps1"
. "$here/../../Source/Classes/VSTeamPermissions.ps1"
. "$here/../../Source/Classes/VSTeamProject.ps1"
. "$here/../../Source/Private/applyTypes.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/Get-VSTeamPool.ps1"
. "$here/../../Source/Public/Get-VSTeamProject.ps1"
. "$here/../../Source/Classes/$sut"
#endregion

Describe "VSTeamAccount" {
   Context 'Constructor' {
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
}