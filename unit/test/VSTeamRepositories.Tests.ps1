Set-StrictMode -Version Latest

Describe "VSTeamRepositories" {
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
      . "$PSScriptRoot/../../Source/Classes/VSTeamRef.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamBuildDefinitionProcessPhaseStep.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamBuildDefinitionProcessPhase.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamBuildDefinitionProcess.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamUserEntitlement.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamPool.ps1"
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
      . "$PSScriptRoot/../../Source/Classes/VSTeamProject.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamGitRepository.ps1"
      . "$PSScriptRoot/../../Source/Private/applyTypes.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamGitRepository.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamGitRef.ps1"
      . "$PSScriptRoot/../../Source/Classes/$sut"
   }

   Context 'Constructor' {
      BeforeAll {
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
         $repository = $repositories.GetChildItem()[0]
         $ref = $repository.GetChildItem()[0]
      }

      It 'Should create Repositories' {
         $repositories | Should -Not -Be $null
      }

      It 'Should return repository' {
         $repository | Should -Not -Be $null
      }

      It 'Should return ref' {
         $ref | Should -Not -Be $null
      }
   }
}