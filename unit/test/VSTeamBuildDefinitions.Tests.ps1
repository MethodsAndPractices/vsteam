Set-StrictMode -Version Latest

Describe "VSTeamBuildDefinitions" {
   BeforeAll {
      Import-Module SHiPS
      
      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")
      
      . "$PSScriptRoot/../../Source/Classes/VSTeamLeaf.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamDirectory.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProjectCache.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectCompleter.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectValidateAttribute.ps1"
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
      . "$PSScriptRoot/../../Source/Classes/$sut"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProject.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamGitRepository.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamBuildDefinition.ps1"
      . "$PSScriptRoot/../../Source/Private/applyTypes.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamBuildDefinition.ps1"
      
      $buildDefResultsAzD = Get-Content "$PSScriptRoot\sampleFiles\buildDefAzD.json" -Raw | ConvertFrom-Json
      $buildDefResults2017 = Get-Content "$PSScriptRoot\sampleFiles\buildDef2017.json" -Raw | ConvertFrom-Json
      $buildDefResults2018 = Get-Content "$PSScriptRoot\sampleFiles\buildDef2018.json" -Raw | ConvertFrom-Json
      $buildDefResultsVSTS = Get-Content "$PSScriptRoot\sampleFiles\buildDefvsts.json" -Raw | ConvertFrom-Json
      $buildDefResultsyaml = Get-Content "$PSScriptRoot\sampleFiles\buildDefyaml.json" -Raw | ConvertFrom-Json

      # Mock the call to Get-Projects by the dynamic parameter for ProjectName
      Mock Invoke-RestMethod { return @() } -ParameterFilter { $Uri -like "*_apis/projects*" }
   }

   Context "Server 2017 Constructor" {
      BeforeAll {
         Mock Get-VSTeamBuildDefinition { return @([VSTeamBuildDefinition]::new($buildDefResults2017.value[0], 'TestProject')) }

         $buildDefinitions = [VSTeamBuildDefinitions]::new('Build Definitions', 'TestProject')

         $hasSteps = $buildDefinitions.GetChildItem()[0]

         $steps = $hasSteps.GetChildItem()
      }

      It 'Should create Build definitions' {
         $buildDefinitions | Should -Not -Be $null
      }
      
      It 'Should have Steps' {
         $hasSteps | Should -Not -Be $null
      }

      It 'Should parse steps' {
         $steps.Length | Should -Be 10
      }
   }

   Context 'Server 2018 Constructor' {
      BeforeAll {
         Mock Get-VSTeamBuildDefinition { return @([VSTeamBuildDefinition]::new($buildDefResults2018.value[0], 'TestProject')) }

         $buildDefinitions = [VSTeamBuildDefinitions]::new('Build Definitions', 'TestProject')

         $hasSteps = $buildDefinitions.GetChildItem()[0]

         $steps = $hasSteps.GetChildItem()
      }

      It 'Should create Build definitions' {
         $buildDefinitions | Should -Not -Be $null
      }

      It 'Should have Steps' {
         $hasSteps | Should -Not -Be $null
      }

      It 'Should parse steps' {
         $steps.Length | Should -Be 9
      }
   }

   Context 'Services' {
      BeforeAll {
         Mock Get-VSTeamBuildDefinition {
            return @(
               [VSTeamBuildDefinition]::new($buildDefResultsVSTS.value[0], 'TestProject'),
               [VSTeamBuildDefinition]::new($buildDefResultsyaml.value[0], 'TestProject'),
               [VSTeamBuildDefinition]::new($buildDefResultsAzD.value[0], 'TestProject')
            )
         }

         $buildDefinitions = [VSTeamBuildDefinitions]::new('Build Definitions', 'TestProject')

         $VSTeamBuildDefinitionWithPhases = $buildDefinitions.GetChildItem()[0]

         $process = $VSTeamBuildDefinitionWithPhases.GetChildItem()[0]
         $steps = $process.GetChildItem()
         $yamlBuild = $buildDefinitions.GetChildItem()[1]
         $yamlFile = $yamlBuild.GetChildItem()
         $version5Build = $buildDefinitions.GetChildItem()[2]
      }

      It 'Should create Build definitions' {
         $buildDefinitions | Should -Not -Be $null
      }

      It 'Should parse phases' {
         $VSTeamBuildDefinitionWithPhases.Process.Phases.Length | Should -Be 1
      }

      It 'Should show steps in tostring' {
         $VSTeamBuildDefinitionWithPhases.Process.ToString() | Should -Be 'Number of phases: 1'
      }      

      It 'Should return process' {
         $process | Should -Not -Be $null
      }

      It 'Should parse steps' {
         $steps.Length | Should -Be 9
      }

      It 'Should have yamlFilename' {
         $yamlFile | Should -Be '.vsts-ci.yml'
      }

      It 'Should have jobCancelTimeoutInMinutes' {
         $version5Build.JobCancelTimeoutInMinutes | Should -Be '5'
      }
   }

   Context 'Build Definitions' {
      BeforeAll {
         Mock Get-VSTeamBuildDefinition { return @(
               [VSTeamBuildDefinition]::new(@{ }, 'TestProject'),
               [VSTeamBuildDefinition]::new(@{ }, 'TestProject')
            )
         }

         $buildDefinitions = [VSTeamBuildDefinitions]::new('Build Definitions', 'TestProject')
      }

      It 'Should create Build definitions' {
         $buildDefinitions | Should -Not -Be $null
      }
   }
}