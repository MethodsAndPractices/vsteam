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
. "$here/../../Source/Classes/ProjectCompleter.ps1"
. "$here/../../Source/Classes/ProcessTemplateCompleter.ps1"
. "$here/../../Source/Classes/UncachedProjectCompleter.ps1"
. "$here/../../Source/Classes/ProcessValidateAttribute.ps1"
. "$here/../../Source/Classes/ProjectValidateAttribute.ps1"
. "$here/../../Source/Classes/UncachedProjectValidateAttribute.ps1"
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

   Mock _getInstance { return 'https://dev.azure.com/test' }
   Mock _getApiVersion { return '1.0-unitTests' }

   Context 'Add-VSTeamProject' {
      Mock Write-Progress

      # Add Project
      Mock Invoke-RestMethod { return @{status = 'inProgress'; id = '123-5464-dee43'; url = 'https://someplace.com' } } -ParameterFilter {
         $Method -eq 'Post' -and
         $Uri -eq "https://dev.azure.com/test/_apis/projects?api-version=$(_getApiVersion Core)"
      }

      # Track Progress
      Mock Invoke-RestMethod {
         # This $i is in the module. Because we use InModuleScope
         # we can see it
         if ($i -gt 9) {
            return @{status = 'succeeded' }
         }

         return @{status = 'inProgress' }
      } -ParameterFilter {
         $Uri -eq 'https://someplace.com'
      }

      # Get-VSTeamProject
      Mock Invoke-RestMethod { return $singleResult } -ParameterFilter {
         $Uri -eq "https://dev.azure.com/test/_apis/projects/Test?api-version=$(_getApiVersion Core)"
      }

      It 'with tfvc should create project with tfvc' {
         Add-VSTeamProject -Name Test -tfvc

         Assert-MockCalled Invoke-RestMethod -Times 1 -Scope It  -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/_apis/projects/Test?api-version=$(_getApiVersion Core)"
         }
         Assert-MockCalled Invoke-RestMethod -Times 1 -Scope It  -ParameterFilter {
            $Method -eq 'Post' -and
            $Uri -eq "https://dev.azure.com/test/_apis/projects?api-version=$(_getApiVersion Core)" -and
            $Body -eq '{"name": "Test", "description": "", "capabilities": {"versioncontrol": { "sourceControlType": "Tfvc"}, "processTemplate":{"templateTypeId": "6b724908-ef14-45cf-84f8-768b5384da45"}}}'
         }
      }
   }

   Context 'Add-VSTeamProject with Agile' {

      Mock Invoke-RestMethod { return @{status = 'inProgress'; id = 1; url = 'https://someplace.com' } } -ParameterFilter { $Method -eq 'Post' -and $Uri -eq "https://dev.azure.com/test/_apis/projects?api-version=$(_getApiVersion Core)" }
      Mock _trackProjectProgress
      Mock Invoke-RestMethod { return $singleResult } -ParameterFilter { $Uri -eq "https://dev.azure.com/test/_apis/projects/Test?api-version=$(_getApiVersion Core)" }
      Mock Get-VSTeamProcess { return @{name = 'Agile'; id = 1 } }

      It 'Should create project with Agile' {
         Add-VSTeamProject -ProjectName Test -processTemplate Agile

         Assert-MockCalled Invoke-RestMethod -Times 1 -ParameterFilter { $Uri -eq "https://dev.azure.com/test/_apis/projects/Test?api-version=$(_getApiVersion Core)" }
         Assert-MockCalled Invoke-RestMethod -Times 1 -ParameterFilter { $Method -eq 'Post' -and $Uri -eq "https://dev.azure.com/test/_apis/projects?api-version=$(_getApiVersion Core)" }
      }
   }

   Context 'Add-VSTeamProject with CMMI' {

      Mock Invoke-RestMethod { return @{status = 'inProgress'; id = 1; url = 'https://someplace.com' } } -ParameterFilter { $Method -eq 'Post' -and $Uri -eq "https://dev.azure.com/test/_apis/projects?api-version=$(_getApiVersion Core)" }
      Mock _trackProjectProgress
      Mock Invoke-RestMethod { return $singleResult } -ParameterFilter { $Uri -eq "https://dev.azure.com/test/_apis/projects/Test?api-version=$(_getApiVersion Core)" }
      Mock Get-VSTeamProcess { return @{name = 'CMMI'; id = 1 } }

      It 'Should create project with CMMI' {
         Add-VSTeamProject -ProjectName Test -processTemplate CMMI

         Assert-MockCalled Invoke-RestMethod -Times 1 -ParameterFilter { $Uri -eq "https://dev.azure.com/test/_apis/projects/Test?api-version=$(_getApiVersion Core)" }
         Assert-MockCalled Invoke-RestMethod -Times 1 -ParameterFilter { $Method -eq 'Post' -and $Uri -eq "https://dev.azure.com/test/_apis/projects?api-version=$(_getApiVersion Core)" }
      }
   }

   Context 'Add-VSTeamProject throws error' {

      Mock Invoke-RestMethod { return @{status = 'inProgress'; id = 1; url = 'https://someplace.com' } } -ParameterFilter { $Method -eq 'Post' -and $Uri -eq "https://dev.azure.com/test/_apis/projects?api-version=$(_getApiVersion Core)" }
      Mock Write-Error
      Mock _trackProjectProgress { throw 'Test error' }
      Mock Invoke-RestMethod { return $singleResult } -ParameterFilter { $Uri -eq "https://dev.azure.com/test/_apis/projects/Test?api-version=$(_getApiVersion Core)" }

      It '_trackProjectProgress errors should throw' { { Add-VSTeamProject -projectName Test -processTemplate CMMI } | Should throw
      }
   }
}