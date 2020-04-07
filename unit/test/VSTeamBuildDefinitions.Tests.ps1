Set-StrictMode -Version Latest

#region include
Import-Module SHiPS

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamLeaf.ps1"
. "$here/../../Source/Classes/VSTeamDirectory.ps1"
. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Classes/VSTeamBuildDefinitionProcessPhaseStep.ps1"
. "$here/../../Source/Classes/VSTeamBuildDefinitionProcessPhase.ps1"
. "$here/../../Source/Classes/VSTeamBuildDefinitionProcess.ps1"
. "$here/../../Source/Classes/VSTeamUserEntitlement.ps1"
. "$here/../../Source/Classes/VSTeamPool.ps1"
. "$here/../../Source/Classes/VSTeamQueue.ps1"
. "$here/../../Source/Classes/VSTeamQueues.ps1"
. "$here/../../Source/Classes/VSTeamRepositories.ps1"
. "$here/../../Source/Classes/VSTeamTeams.ps1"
. "$here/../../Source/Classes/VSTeamReleaseDefinitions.ps1"
. "$here/../../Source/Classes/VSTeamBuild.ps1"
. "$here/../../Source/Classes/VSTeamBuilds.ps1"
. "$here/../../Source/Classes/VSTeamTask.ps1"
. "$here/../../Source/Classes/VSTeamAttempt.ps1"
. "$here/../../Source/Classes/VSTeamEnvironment.ps1"
. "$here/../../Source/Classes/VSTeamRelease.ps1"
. "$here/../../Source/Classes/VSTeamReleases.ps1"
. "$here/../../Source/Classes/$sut"
. "$here/../../Source/Classes/VSTeamProject.ps1"
. "$here/../../Source/Classes/VSTeamGitRepository.ps1"
. "$here/../../Source/Classes/VSTeamBuildDefinition.ps1"
. "$here/../../Source/Private/applyTypes.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/Get-VSTeamBuildDefinition.ps1"
#endregion

Describe "VSTeamBuildDefinitions" {
   $buildDefResultsAzD = Get-Content "$PSScriptRoot\sampleFiles\buildDefAzD.json" -Raw | ConvertFrom-Json
   $buildDefResults2017 = Get-Content "$PSScriptRoot\sampleFiles\buildDef2017.json" -Raw | ConvertFrom-Json
   $buildDefResults2018 = Get-Content "$PSScriptRoot\sampleFiles\buildDef2018.json" -Raw | ConvertFrom-Json
   $buildDefResultsVSTS = Get-Content "$PSScriptRoot\sampleFiles\buildDefvsts.json" -Raw | ConvertFrom-Json
   $buildDefResultsyaml = Get-Content "$PSScriptRoot\sampleFiles\buildDefyaml.json" -Raw | ConvertFrom-Json

   # Mock the call to Get-Projects by the dynamic parameter for ProjectName
   Mock Invoke-RestMethod { return @() } -ParameterFilter { $Uri -like "*_apis/projects*" }

   Context "Server 2017 Constructor" {
      Mock Get-VSTeamBuildDefinition { return @([VSTeamBuildDefinition]::new($buildDefResults2017.value[0], 'TestProject')) }

      $buildDefinitions = [VSTeamBuildDefinitions]::new('Build Definitions', 'TestProject')

      It 'Should create Build definitions' {
         $buildDefinitions | Should Not be $null
      }

      $hasSteps = $buildDefinitions.GetChildItem()[0]

      It 'Should have Steps' {
         $hasSteps | Should Not Be $null
      }

      $steps = $hasSteps.GetChildItem()

      It 'Should parse steps' {
         $steps.Length | Should Be 10
      }
   }

   Context 'Server 2018 Constructor' {
      Mock Get-VSTeamBuildDefinition { return @([VSTeamBuildDefinition]::new($buildDefResults2018.value[0], 'TestProject')) }

      $buildDefinitions = [VSTeamBuildDefinitions]::new('Build Definitions', 'TestProject')

      It 'Should create Build definitions' {
         $buildDefinitions | Should Not be $null
      }

      $hasSteps = $buildDefinitions.GetChildItem()[0]

      It 'Should have Steps' {
         $hasSteps | Should Not Be $null
      }

      $steps = $hasSteps.GetChildItem()

      It 'Should parse steps' {
         $steps.Length | Should Be 9
      }
   }

   Context 'Services' {
      Mock Get-VSTeamBuildDefinition {
         return @(
            [VSTeamBuildDefinition]::new($buildDefResultsVSTS.value[0], 'TestProject'),
            [VSTeamBuildDefinition]::new($buildDefResultsyaml.value[0], 'TestProject'),
            [VSTeamBuildDefinition]::new($buildDefResultsAzD.value[0], 'TestProject')
         )
      }

      $buildDefinitions = [VSTeamBuildDefinitions]::new('Build Definitions', 'TestProject')

      It 'Should create Build definitions' {
         $buildDefinitions | Should Not be $null
      }

      $VSTeamBuildDefinitionWithPhases = $buildDefinitions.GetChildItem()[0]

      It 'Should parse phases' {
         $VSTeamBuildDefinitionWithPhases.Process.Phases.Length | Should Be 1
      }

      It 'Should show steps in tostring' {
         $VSTeamBuildDefinitionWithPhases.Process.ToString() | Should Be 'Number of phases: 1'
      }

      $process = $VSTeamBuildDefinitionWithPhases.GetChildItem()[0]

      It 'Should return process' {
         $process | Should Not Be $null
      }

      $steps = $process.GetChildItem()

      It 'Should parse steps' {
         $steps.Length | Should Be 9
      }

      $yamlBuild = $buildDefinitions.GetChildItem()[1]
      $yamlFile = $yamlBuild.GetChildItem()

      It 'Should have yamlFilename' {
         $yamlFile | Should Be '.vsts-ci.yml'
      }

      $version5Build = $buildDefinitions.GetChildItem()[2]

      It 'Should have jobCancelTimeoutInMinutes' {
         $version5Build.JobCancelTimeoutInMinutes | Should Be '5'
      }
   }

   Context 'Build Definitions' {
      Mock Get-VSTeamBuildDefinition { return @(
            [VSTeamBuildDefinition]::new(@{ }, 'TestProject'),
            [VSTeamBuildDefinition]::new(@{ }, 'TestProject')
         )
      }

      $buildDefinitions = [VSTeamBuildDefinitions]::new('Build Definitions', 'TestProject')

      It 'Should create Build definitions' {
         $buildDefinitions | Should Not be $null
      }

      # $VSTeamBuildDefinitionWithPhases = $buildDefinitions.GetChildItem()[0]

      # $yamlBuild = $buildDefinitions.GetChildItem()[1]
   }
}