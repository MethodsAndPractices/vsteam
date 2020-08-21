Set-StrictMode -Version Latest

Describe "VSTeamGitRepository" {
   BeforeAll {
      Import-Module SHiPS
      Add-Type -Path "$PSScriptRoot/../../dist/bin/vsteam-lib.dll"
   
      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")
   
      . "$PSScriptRoot/../../Source/Classes/VSTeamLeaf.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamDirectory.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamUserEntitlement.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamRepositories.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamReleaseDefinitions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamTask.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamAttempt.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamEnvironment.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamRelease.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamReleases.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamBuild.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamBuilds.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamBuildDefinitions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamGitRepository.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamBuildDefinitionProcessPhaseStep.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamBuildDefinitionProcessPhase.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamBuildDefinitionProcess.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamBuildDefinition.ps1"
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
   
      # Prime the project cache with an empty list. This will make sure
      # any project name used will pass validation and Get-VSTeamProject 
      # will not need to be called.
      [vsteam_lib.ProjectCache]::Update([string[]]@())

      Mock Show-Browser
      Mock _getInstance { return 'https://dev.azure.com/test' }
   }

   Context 'Show-VSTeamGitRepository' {
      it 'by project should return url for mine' {
         Show-VSTeamGitRepository -projectName project

         Should -Invoke Show-Browser -Exactly -Times 1 -Scope It -ParameterFilter {
            $url -eq 'https://dev.azure.com/test/_git/project'
         }
      }

      it 'by remote url should return url for mine' {
         Show-VSTeamGitRepository -RemoteUrl 'https://dev.azure.com/test/_git/project'

         Should -Invoke Show-Browser -Exactly -Times 1 -Scope It -ParameterFilter {
            $url -eq 'https://dev.azure.com/test/_git/project'
         }
      }
   }
}