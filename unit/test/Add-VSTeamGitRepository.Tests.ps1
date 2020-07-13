Set-StrictMode -Version Latest

Describe "VSTeamGitRepository" {
   BeforeAll {
      Import-Module SHiPS

      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

      . "$PSScriptRoot/../../Source/Classes/VSTeamLeaf.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamDirectory.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProjectCache.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamUserEntitlement.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamTeams.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamRepositories.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamReleaseDefinitions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamTask.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamAttempt.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamEnvironment.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamRelease.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamReleases.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamBuild.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamBuilds.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamQueues.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamBuildDefinitions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProject.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamGitRepository.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamBuildDefinitionProcessPhaseStep.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamBuildDefinitionProcessPhase.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamBuildDefinitionProcess.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamPool.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamQueue.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamBuildDefinition.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectCompleter.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectValidateAttribute.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Private/applyTypes.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamQueue.ps1"
      . "$PSScriptRoot/../../Source/Public/Remove-VSTeamAccount.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamBuildDefinition.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamProject.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamGitRepository.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Private/applyTypes.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"
   }

   Context 'Add-VSTeamGitRepository' {
      ## Arrange
      BeforeAll {
         $singleResult = [PSCustomObject]@{
            id            = ''
            url           = ''
            sshUrl        = ''
            remoteUrl     = ''
            defaultBranch = ''
            size          = 0
            name          = 'testRepo'
            project       = [PSCustomObject]@{
               name        = 'Project'
               id          = 1
               description = ''
               url         = ''
               state       = ''
               revision    = ''
               visibility  = ''
            }
         }

         # These two lines will force a refresh of the project
         # cache and return an empty list.
         Mock _getProjects { return @() }
         Mock _hasProjectCacheExpired { return $true }

         Mock Invoke-RestMethod { return $singleResult }

         Mock _getInstance { return 'https://dev.azure.com/test' }
         Mock _getApiVersion { return '1.0-gitUnitTests' } -ParameterFilter { $Service -eq 'Git' }
      }

      It 'by name should add Git repo' {
         Add-VSTeamGitRepository -Name 'testRepo' -ProjectName 'test'

         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Method -eq "Post" -and
            $Uri -eq "https://dev.azure.com/test/test/_apis/git/repositories?api-version=1.0-gitUnitTests" -and
            $Body -like "*testRepo*"
         }
      }
   }
}