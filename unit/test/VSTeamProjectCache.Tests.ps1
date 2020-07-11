Set-StrictMode -Version Latest

Describe "VSTeamProjectCache" {
   BeforeAll {
      Import-Module SHiPS

      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

      . "$PSScriptRoot/../../Source/Classes/VSTeamLeaf.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamDirectory.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProjectCache.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectCompleter.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectValidateAttribute.ps1"
      . "$PSScriptRoot/../../Source/Classes/UncachedProjectCompleter.ps1"
      . "$PSScriptRoot/../../Source/Classes/UncachedProjectValidateAttribute.ps1"
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
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Private/applyTypes.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamQueue.ps1"
      . "$PSScriptRoot/../../Source/Public/Remove-VSTeamAccount.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamBuildDefinition.ps1"
      . "$PSScriptRoot/../../Source/Classes/$sut"
   }

   Context 'GetCurrent' {
      BeforeAll {
         # Arrange
         Mock _getProjects { return  ConvertFrom-Json '["Demo", "Universal"]' }

         Mock Get-Date {
            return New-Object DateTime 1970, 1, 1, 0, 15, 0, ([DateTimeKind]::Utc)
         }

         # Act
         $actual = [VSTeamProjectCache]::GetCurrent($true)
      }

      It 'Should call _getProjects' {
         Should -Invoke _getProjects -Exactly -Scope Context -Times 1
      }

      It 'Should return array' {
         # Assert
         $actual.length | Should -Be 2
      }

      It 'Should set timestamp' {
         # Assert
         [VSTeamProjectCache]::timestamp | Should -Be 15
      }
   }
}