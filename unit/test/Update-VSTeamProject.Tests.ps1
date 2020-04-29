Set-StrictMode -Version Latest

#region include
Import-Module SHiPS

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamLeaf.ps1"
. "$here/../../Source/Classes/VSTeamDirectory.ps1"
. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Classes/VSTeamProcessCache.ps1"
. "$here/../../Source/Classes/ProjectCompleter.ps1"
. "$here/../../Source/Classes/ProjectValidateAttribute.ps1"
. "$here/../../Source/Classes/UncachedProjectCompleter.ps1"
. "$here/../../Source/Classes/UncachedProjectValidateAttribute.ps1"
. "$here/../../Source/Classes/ProcessTemplateCompleter.ps1"
. "$here/../../Source/Classes/ProcessValidateAttribute.ps1"
. "$here/../../Source/Classes/VSTeamUserEntitlement.ps1"
. "$here/../../Source/Classes/VSTeamTeams.ps1"
. "$here/../../Source/Classes/VSTeamRepositories.ps1"
. "$here/../../Source/Classes/VSTeamReleaseDefinitions.ps1"
. "$here/../../Source/Classes/VSTeamTask.ps1"
. "$here/../../Source/Classes/VSTeamAttempt.ps1"
. "$here/../../Source/Classes/VSTeamEnvironment.ps1"
. "$here/../../Source/Classes/VSTeamRelease.ps1"
. "$here/../../Source/Classes/VSTeamReleases.ps1"
. "$here/../../Source/Classes/VSTeamBuild.ps1"
. "$here/../../Source/Classes/VSTeamBuilds.ps1"
. "$here/../../Source/Classes/VSTeamQueues.ps1"
. "$here/../../Source/Classes/VSTeamBuildDefinitions.ps1"
. "$here/../../Source/Classes/VSTeamProject.ps1"
. "$here/../../Source/Classes/VSTeamGitRepository.ps1"
. "$here/../../Source/Classes/VSTeamBuildDefinitionProcessPhaseStep.ps1"
. "$here/../../Source/Classes/VSTeamBuildDefinitionProcessPhase.ps1"
. "$here/../../Source/Classes/VSTeamBuildDefinitionProcess.ps1"
. "$here/../../Source/Classes/VSTeamPool.ps1"
. "$here/../../Source/Classes/VSTeamQueue.ps1"
. "$here/../../Source/Classes/VSTeamBuildDefinition.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Private/applyTypes.ps1"
. "$here/../../Source/Public/Get-VSTeamQueue.ps1"
. "$here/../../Source/Public/Remove-VSTeamAccount.ps1"
. "$here/../../Source/Public/Get-VSTeamBuildDefinition.ps1"
. "$here/../../Source/Public/Get-VSTeamProject.ps1"
. "$here/../../Source/Public/$sut"
#endregion

Describe 'VSTeamProject' {
   Mock _getApiVersion { return '1.0-unitTests' }
   Mock _getInstance { return 'https://dev.azure.com/test' }

   $singleResult = [PSCustomObject]@{
      name        = 'Test'
      description = ''
      url         = ''
      id          = '123-5464-dee43'
      state       = ''
      visibility  = ''
      revision    = 0
      defaultTeam = [PSCustomObject]@{ }
      _links      = [PSCustomObject]@{ }
   }

   Context 'Update-VSTeamProject' {
      Mock Invoke-RestMethod {
         # Write-Host $args
         return $singleResult
      }
      Mock Invoke-RestMethod {
         # Write-Host "single result $args"
         return $singleResult
      } -ParameterFilter { $Uri -eq "https://dev.azure.com/test/_apis/projects/Test?api-version=$(_getApiVersion Core)" }
      Mock Invoke-RestMethod {
         # Write-Host "in progress $args"
         return @{status = 'inProgress'; url = 'https://someplace.com' }
      } -ParameterFilter { $Method -eq 'Patch' }
      Mock _trackProjectProgress {
         # Write-Host "in progress $args"
      }
      Mock Invoke-RestMethod { return $singleResult } -ParameterFilter { $Uri -eq "https://dev.azure.com/test/_apis/projects/Testing123?api-version=$(_getApiVersion Core)" }

      It 'with no op by id should not call Invoke-RestMethod' {
         Update-VSTeamProject -id '123-5464-dee43'

         Assert-MockCalled Invoke-RestMethod -Exactly 0
      }

      It 'with newName should change name' {
         Update-VSTeamProject -ProjectName Test -newName Testing123 -Force

         Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter { $Uri -eq "https://dev.azure.com/test/_apis/projects/Test?api-version=$(_getApiVersion Core)" }
         Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter { $Method -eq 'Patch' -and $Body -eq '{"name": "Testing123"}' }
         Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter { $Uri -eq "https://dev.azure.com/test/_apis/projects/Testing123?api-version=$(_getApiVersion Core)" }
      }

      It 'with newDescription should change description' {
         Update-VSTeamProject -ProjectName Test -newDescription Testing123 -Force

         Assert-MockCalled Invoke-RestMethod -Exactly -Times 2 -Scope It -ParameterFilter { $Uri -eq "https://dev.azure.com/test/_apis/projects/Test?api-version=$(_getApiVersion Core)" }
         Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter { $Method -eq 'Patch' -and $Body -eq '{"description": "Testing123"}' }
      }

      It 'with new name and description should not call Invoke-RestMethod' {
         Update-VSTeamProject -ProjectName Test -newName Testing123 -newDescription Testing123 -Force

         Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter { $Uri -eq "https://dev.azure.com/test/_apis/projects/Test?api-version=$(_getApiVersion Core)" }
         Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter { $Method -eq 'Patch' }
         Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter { $Uri -eq "https://dev.azure.com/test/_apis/projects/Testing123?api-version=$(_getApiVersion Core)" }
      }
   }
}