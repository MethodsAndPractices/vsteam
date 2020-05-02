Set-StrictMode -Version Latest

#region include
Import-Module SHiPS

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamLeaf.ps1"
. "$here/../../Source/Classes/VSTeamDirectory.ps1"
. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Classes/ProjectCompleter.ps1"
. "$here/../../Source/Classes/ProjectValidateAttribute.ps1"
. "$here/../../Source/Classes/VSTeamUserEntitlement.ps1"
. "$here/../../Source/Classes/VSTeamRef.ps1"
. "$here/../../Source/Classes/VSTeamBuildDefinitionProcessPhaseStep.ps1"
. "$here/../../Source/Classes/VSTeamBuildDefinitionProcessPhase.ps1"
. "$here/../../Source/Classes/VSTeamBuildDefinitionProcess.ps1"
. "$here/../../Source/Classes/VSTeamUserEntitlement.ps1"
. "$here/../../Source/Classes/VSTeamPool.ps1"
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
. "$here/../../Source/Classes/VSTeamProject.ps1"
. "$here/../../Source/Classes/VSTeamGitRepository.ps1"
. "$here/../../Source/Private/applyTypes.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/Get-VSTeamGitRepository.ps1"
. "$here/../../Source/Public/Get-VSTeamGitRef.ps1"
. "$here/../../Source/Classes/$sut"
#endregion

Describe "VSTeamRepositories" {
   Context 'Constructor' {
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
                  id          = '123 - 5464-dee43'
                  state       = ''
                  visibility  = ''
                  revision    = 0
                  defaultTeam = [PSCustomObject]@{ }
                  _links      = [PSCustomObject]@{ }
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
}