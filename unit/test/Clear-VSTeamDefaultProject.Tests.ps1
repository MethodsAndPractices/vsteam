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
. "$here/../../Source/Public/Get-VSTeamProcess.ps1"
. "$here/../../Source/Public/Get-VSTeamProject.ps1"
. "$here/../../Source/Public/$sut"
#endregion

Describe 'VSTeamProject' {
   Mock _getInstance { return 'https://dev.azure.com/test' }

   Context 'Clear-VSTeamDefaultProject on Non Windows' {
      AfterAll {
         $Global:PSDefaultParameterValues.Remove("*-vsteam*:projectName")
      }

      Mock _isOnWindows { return $false }

      It 'should clear default project' {
         $Global:PSDefaultParameterValues['*-vsteam*:projectName'] = 'MyProject'

         Clear-VSTeamDefaultProject

         $Global:PSDefaultParameterValues['*-vsteam*:projectName'] | Should BeNullOrEmpty
      }
   }

   Context 'Clear-VSTeamDefaultProject as Non-Admin on Windows' {
      AfterAll {
         $Global:PSDefaultParameterValues.Remove("*-vsteam*:projectName")
      }
         
      Mock _isOnWindows { return $true }
      Mock _testAdministrator { return $false }

      It 'should clear default project' {
         $Global:PSDefaultParameterValues['*-vsteam*:projectName'] = 'MyProject'

         Clear-VSTeamDefaultProject

         $Global:PSDefaultParameterValues['*-vsteam*:projectName'] | Should BeNullOrEmpty
      }
   }

   Context 'Clear-VSTeamDefaultProject as Admin on Windows' {
      AfterAll {
         $Global:PSDefaultParameterValues.Remove("*-vsteam*:projectName")
      }

      Mock _isOnWindows { return $true }
      Mock _testAdministrator { return $true }

      It 'should clear default project' {
         $Global:PSDefaultParameterValues['*-vsteam*:projectName'] = 'MyProject'

         Clear-VSTeamDefaultProject

         $Global:PSDefaultParameterValues['*-vsteam*:projectName'] | Should BeNullOrEmpty
      }
   }
}