Set-StrictMode -Version Latest

Import-Module SHiPS

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamLeaf.ps1"
. "$here/../../Source/Classes/VSTeamDirectory.ps1"
. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
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

# Just in case it was loaded. If we don't do
# this some test may fail
Remove-VSTeamAccount | Out-Null
   
$resultsVSTS = Get-Content "$PSScriptRoot\sampleFiles\buildDefvsts.json" -Raw | ConvertFrom-Json

# Sample result of a single build
$singleResult = [PSCustomObject]@{
   logs              = [PSCustomObject]@{ }
   queue             = [PSCustomObject]@{ }
   _links            = [PSCustomObject]@{ }
   project           = [PSCustomObject]@{ }
   repository        = [PSCustomObject]@{ }
   requestedFor      = [PSCustomObject]@{ }
   orchestrationPlan = [PSCustomObject]@{ }
   definition        = [PSCustomObject]@{ }
   lastChangedBy     = [PSCustomObject]@{ }
   requestedBy       = [PSCustomObject]@{ }
}

Describe 'Add-VSTeamBuild' {
   # Load the mocks to create the project name dynamic parameter
   . "$PSScriptRoot\mocks\mockProjectNameDynamicParamNoPSet.ps1"

   # Set the account to use for testing. A normal user would do this
   # using the Set-VSTeamAccount function.
   Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable

   # Mock the call to Get-Projects by the dynamic parameter for ProjectName
   Mock Invoke-RestMethod { return @() } -ParameterFilter {
      $Uri -like "*_apis/projects*"
   }

   Context 'by name' {
      Mock Invoke-RestMethod { return $singleResult }
      Mock Get-VSTeamBuildDefinition { return $resultsVSTS.value }

      It 'should add build' {
         Add-VSTeamBuild -ProjectName project -BuildDefinitionName 'aspdemo-CI'

         # Call to queue build.
         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            ($Body | ConvertFrom-Json).definition.id -eq 699 -and
            $Uri -eq "https://dev.azure.com/test/project/_apis/build/builds?api-version=$([VSTeamVersions]::Build)"
         }
      }
   }

   Context 'by id' {
      Mock Invoke-RestMethod {
         return $singleResult
      }

      It 'should add build' {
         Add-VSTeamBuild -ProjectName project -BuildDefinitionId 2

         # Call to queue build.
         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            ($Body | ConvertFrom-Json).definition.id -eq 2 -and
            $Uri -eq "https://dev.azure.com/test/project/_apis/build/builds?api-version=$([VSTeamVersions]::Build)"
         }
      }
   }

   Context 'with source branch' {
      Mock Invoke-RestMethod {
         return $singleResult
      }

      It 'should add build' {
         Add-VSTeamBuild -ProjectName project -BuildDefinitionId 2 -SourceBranch 'refs/heads/dev'

         # Call to queue build.
         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            ($Body | ConvertFrom-Json).definition.id -eq 2 -and
            ($Body | ConvertFrom-Json).sourceBranch -eq 'refs/heads/dev' -and
            $Uri -eq "https://dev.azure.com/test/project/_apis/build/builds?api-version=$([VSTeamVersions]::Build)"
         }
      }
   }

   Context 'with parameters' {
      Mock Invoke-RestMethod {
         return $singleResult
      }

      It 'should add build' {
         Add-VSTeamBuild -ProjectName project -BuildDefinitionId 2 -BuildParameters @{'system.debug' = 'true' }

         # Call to queue build.
         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            ($Body | ConvertFrom-Json).definition.id -eq 2 -and
            (($Body | ConvertFrom-Json).parameters | ConvertFrom-Json).'system.debug' -eq 'true' -and
            $Uri -eq "https://dev.azure.com/test/project/_apis/build/builds?api-version=$([VSTeamVersions]::Build)"
         }
      }
   }
}

Describe 'Add-VSTeamBuild' {
   . "$PSScriptRoot\mocks\mockProjectNameDynamicParam.ps1"

   Mock _useWindowsAuthenticationOnPremise { return $true }

   # Mock the call to Get-Projects by the dynamic parameter for ProjectName
   Mock Invoke-RestMethod { return @() } -ParameterFilter {
      $Uri -like "*_apis/projects*"
   }

   Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' } -Verifiable

   Context 'by id on TFS local Auth' {
      AfterAll {
         $Global:PSDefaultParameterValues.Remove("*:projectName")
      }

      Mock Get-VSTeamQueue {
         return [PSCustomObject]@{
            name = "MyQueue"
            id   = 3
         }
      }

      Mock Get-VSTeamBuildDefinition {
         return @{ name = "MyBuildDef" }
      }

      Mock Invoke-RestMethod { return $singleResult } -Verifiable -ParameterFilter {
         ($Body | ConvertFrom-Json).definition.id -eq 2 -and
         ($Body | ConvertFrom-Json).queue.id -eq 3 -and
         $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/build/builds?api-version=$([VSTeamVersions]::Build)"
      }

      Mock Invoke-RestMethod { throw 'Invoke-RestMethod called with wrong URL' }

      $Global:PSDefaultParameterValues["*:projectName"] = 'Project'

      Add-VSTeamBuild -projectName project -BuildDefinitionId 2 -QueueName MyQueue

      It 'should add build' {
         # Call to queue build.
         Assert-VerifiableMock
      }
   }

   Context 'with parameters on TFS local Auth' {
      AfterAll {
         $Global:PSDefaultParameterValues.Remove("*:projectName")
      }

      Mock Get-VSTeamQueue { return [PSCustomObject]@{
            name = "MyQueue"
            id   = 3
         }
      }
      Mock Get-VSTeamBuildDefinition { return @{ name = "MyBuildDef" } }

      Mock Invoke-RestMethod { return $singleResult } -Verifiable -ParameterFilter {
         ($Body | ConvertFrom-Json).definition.id -eq 2 -and
         ($Body | ConvertFrom-Json).queue.id -eq 3 -and
         (($Body | ConvertFrom-Json).parameters | ConvertFrom-Json).'system.debug' -eq 'true' -and
         $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/build/builds?api-version=$([VSTeamVersions]::Build)"
      }

      Mock Invoke-RestMethod { throw 'Invoke-RestMethod called with wrong URL' }

      $Global:PSDefaultParameterValues["*:projectName"] = 'Project'

      Add-VSTeamBuild -projectName project -BuildDefinitionId 2 -QueueName MyQueue -BuildParameters @{'system.debug' = 'true' }

      It 'should add build' {
         # Call to queue build.
         Assert-VerifiableMock
      }
   }

   Context 'with source branch on TFS local auth' {
      AfterAll {
         $Global:PSDefaultParameterValues.Remove("*:projectName")
      }

      Mock Get-VSTeamQueue { return [PSCustomObject]@{
            name = "MyQueue"
            id   = 3
         }
      }

      Mock Get-VSTeamBuildDefinition { return @{ name = "MyBuildDef" } }

      Mock Invoke-RestMethod { return $singleResult } -Verifiable -ParameterFilter {
         ($Body | ConvertFrom-Json).definition.id -eq 2 -and
         ($Body | ConvertFrom-Json).queue.id -eq 3 -and
         ($Body | ConvertFrom-Json).sourceBranch -eq 'refs/heads/dev' -and
         $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/build/builds?api-version=$([VSTeamVersions]::Build)"
      }

      Mock Invoke-RestMethod { throw 'Invoke-RestMethod called with wrong URL' }

      $Global:PSDefaultParameterValues["*:projectName"] = 'Project'

      Add-VSTeamBuild -projectName project -BuildDefinitionId 2 -QueueName MyQueue -SourceBranch refs/heads/dev

      It 'should add build' {
         # Call to queue build.
         Assert-VerifiableMock
      }
   }
}