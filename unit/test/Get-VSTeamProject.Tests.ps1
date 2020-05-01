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
. "$here/../../Source/Classes/UncachedProjectCompleter.ps1"
. "$here/../../Source/Classes/UncachedProjectValidateAttribute.ps1"
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
. "$here/../../Source/Public/$sut"
#endregion

Describe 'VSTeamProject' {
   Mock _getInstance { return 'https://dev.azure.com/test' }
   Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Core' }

   $results = [PSCustomObject]@{
      value = [PSCustomObject]@{
         name        = 'Test'
         description = ''
         url         = ''
         id          = '123-5464-dee43'
         state       = ''
         visibility  = ''
         revision    = 0
         _links      = [PSCustomObject]@{ }
      }
   }

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

   Context 'Get-VSTeamProject' {

      BeforeAll {
         $env:TEAM_TOKEN = '1234'
      }

      AfterAll {
         $env:TEAM_TOKEN = $null
      }

      Mock Invoke-RestMethod { return $results }
      Mock Invoke-RestMethod { return $singleResult } -ParameterFilter { $Uri -like "*TestProject*" }

      It 'with no parameters using BearerToken should return projects' {
         Get-VSTeamProject

         # Make sure it was called with the correct URI
         Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "*https://dev.azure.com/test/_apis/projects*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Uri -like "*`$top=100*" -and
            $Uri -like "*stateFilter=WellFormed*"
         }
      }

      It 'with top 10 should return top 10 projects' {
         Get-VSTeamProject -top 10

         # Make sure it was called with the correct URI
         Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "*https://dev.azure.com/test/_apis/projects*" -and
            $Uri -like "*`$top=10*" -and
            $Uri -like "*stateFilter=WellFormed*"
         }
      }

      It 'with skip 1 should skip first project' {
         Get-VSTeamProject -skip 1

         # Make sure it was called with the correct URI
         Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "*https://dev.azure.com/test/_apis/projects*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Uri -like "*`$skip=1*" -and
            $Uri -like "*`$top=100*" -and
            $Uri -like "*stateFilter=WellFormed*"
         }
      }

      It 'with stateFilter All should return All projects' {
         Get-VSTeamProject -stateFilter 'All'

         # Make sure it was called with the correct URI
         Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "*https://dev.azure.com/test/_apis/projects*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Uri -like "*`$top=100*" -and
            $Uri -like "*stateFilter=All*"
         }
      }

      It 'with no Capabilities by name should return the project' {
         Get-VSTeamProject -Name TestProject

         # Make sure it was called with the correct URI
         Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/_apis/projects/TestProject?api-version=$(_getApiVersion Core)"
         }
      }

      It 'with Capabilities by name should return the project with capabilities' {
         Get-VSTeamProject -projectId TestProject -includeCapabilities

         # Make sure it was called with the correct URI
         Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "*https://dev.azure.com/test/_apis/projects/TestProject*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Uri -like "*includeCapabilities=True*"
         }
      }
   }
}