Set-StrictMode -Version Latest

Describe 'VSTeamProject' {
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
      . "$PSScriptRoot/../../Source/Public/$sut"
   
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
   }

   Context 'Get-VSTeamProject' {
      BeforeAll {
         $env:TEAM_TOKEN = '1234'         

         Mock Invoke-RestMethod { return $results }
         Mock Invoke-RestMethod { return $singleResult } -ParameterFilter { $Uri -like "*TestProject*" }
      }

      AfterAll {
         $env:TEAM_TOKEN = $null
      }

      It 'with no parameters using BearerToken should return projects' {
         Get-VSTeamProject

         # Make sure it was called with the correct URI
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "*https://dev.azure.com/test/_apis/projects*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Uri -like "*`$top=100*" -and
            $Uri -like "*stateFilter=WellFormed*"
         }
      }

      It 'with top 10 should return top 10 projects' {
         Get-VSTeamProject -top 10

         # Make sure it was called with the correct URI
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "*https://dev.azure.com/test/_apis/projects*" -and
            $Uri -like "*`$top=10*" -and
            $Uri -like "*stateFilter=WellFormed*"
         }
      }

      It 'with skip 1 should skip first project' {
         Get-VSTeamProject -skip 1

         # Make sure it was called with the correct URI
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
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
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "*https://dev.azure.com/test/_apis/projects*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Uri -like "*`$top=100*" -and
            $Uri -like "*stateFilter=All*"
         }
      }

      It 'with no Capabilities by name should return the project' {
         Get-VSTeamProject -Name TestProject

         # Make sure it was called with the correct URI
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/_apis/projects/TestProject?api-version=$(_getApiVersion Core)"
         }
      }

      It 'with Capabilities by name should return the project with capabilities' {
         Get-VSTeamProject -projectId TestProject -includeCapabilities

         # Make sure it was called with the correct URI
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "*https://dev.azure.com/test/_apis/projects/TestProject*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Uri -like "*includeCapabilities=True*"
         }
      }
   }
}