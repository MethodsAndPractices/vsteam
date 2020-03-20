Set-StrictMode -Version Latest

#region include
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
#endregion

Describe 'VSTeamBuild' {
   $resultsVSTS = Get-Content "$PSScriptRoot\sampleFiles\buildDefvsts.json" -Raw | ConvertFrom-Json

   # Sample result of a single build
   $singleResult = Get-Content "$PSScriptRoot\sampleFiles\buildSingleResult.json" -Raw | ConvertFrom-Json

   Context 'Add-VSTeamBuild' {
      Context 'Services' {
         ## Arrange
         BeforeAll {
            $Global:PSDefaultParameterValues.Remove("*:projectName")
         }
         
         # Load the mocks to create the project name dynamic parameter
         . "$PSScriptRoot\mocks\mockProjectNameDynamicParamNoPSet.ps1"

         # Set the account to use for testing. A normal user would do this
         # using the Set-VSTeamAccount function.
         Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable

         Mock Invoke-RestMethod { return $singleResult }
         Mock Get-VSTeamBuildDefinition { return $resultsVSTS.value }

         It 'by name should add build' {
            ## Act
            Add-VSTeamBuild -ProjectName project -BuildDefinitionName 'aspdemo-CI'

            ## Assert
            # Call to queue build.
            Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               ($Body | ConvertFrom-Json).definition.id -eq 699 -and
               $Uri -eq "https://dev.azure.com/test/project/_apis/build/builds?api-version=$([VSTeamVersions]::Build)"
            }
         }

         It 'by id should add build' {
            ## Act
            Add-VSTeamBuild -ProjectName project -BuildDefinitionId 2

            ## Assert
            # Call to queue build.
            Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               ($Body | ConvertFrom-Json).definition.id -eq 2 -and
               $Uri -eq "https://dev.azure.com/test/project/_apis/build/builds?api-version=$([VSTeamVersions]::Build)"
            }
         }

         It 'with source branch should add build' {
            ## Act
            Add-VSTeamBuild -ProjectName project -BuildDefinitionId 2 -SourceBranch 'refs/heads/dev'

            ## Assert
            # Call to queue build.
            Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               ($Body | ConvertFrom-Json).definition.id -eq 2 -and
               ($Body | ConvertFrom-Json).sourceBranch -eq 'refs/heads/dev' -and
               $Uri -eq "https://dev.azure.com/test/project/_apis/build/builds?api-version=$([VSTeamVersions]::Build)"
            }
         }

         It 'with parameters should add build' {
            ## Act
            Add-VSTeamBuild -ProjectName project -BuildDefinitionId 2 -BuildParameters @{'system.debug' = 'true' }

            ## Assert
            # Call to queue build.
            Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               ($Body | ConvertFrom-Json).definition.id -eq 2 -and
               (($Body | ConvertFrom-Json).parameters | ConvertFrom-Json).'system.debug' -eq 'true' -and
               $Uri -eq "https://dev.azure.com/test/project/_apis/build/builds?api-version=$([VSTeamVersions]::Build)"
            }
         }
      }

      Context 'Server' {
         ## Arrange
         . "$PSScriptRoot\mocks\mockProjectNameDynamicParam.ps1"

         Mock _useWindowsAuthenticationOnPremise { return $true }
         Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' } -Verifiable

         AfterAll {
            $Global:PSDefaultParameterValues.Remove("*:projectName")
         }

         Mock Invoke-RestMethod {
            # Write-Host $args
            return $singleResult
         }

         Mock Get-VSTeamQueue { return [PSCustomObject]@{
               name = "MyQueue"
               id   = 3
            }
         }

         Mock Get-VSTeamBuildDefinition { return @{ name = "MyBuildDef" } }

         It 'by id on TFS local Auth should add build' {
            ## Arrange
            $Global:PSDefaultParameterValues["*:projectName"] = 'Project'

            ## Act
            Add-VSTeamBuild -projectName project -BuildDefinitionId 2 -QueueName MyQueue

            ## Assert
            # Call to queue build.
            Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               # The write-host below is great for seeing how many ways the mock is called.
               # Write-Host "Assert Mock $Uri"
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/build/builds?api-version=$([VSTeamVersions]::Build)" -and
               ($Body | ConvertFrom-Json).definition.id -eq 2 -and
               ($Body | ConvertFrom-Json).queue.id -eq 3
            }
         }

         It 'with parameters on TFS local Auth should add build' {
            ## Arrange
            $Global:PSDefaultParameterValues["*:projectName"] = 'Project'

            ## Act
            Add-VSTeamBuild -projectName project -BuildDefinitionId 2 -QueueName MyQueue -BuildParameters @{'system.debug' = 'true' }

            ## Assert
            # Call to queue build.
            Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               # The write-host below is great for seeing how many ways the mock is called.
               # Write-Host "Assert Mock $Uri"
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/build/builds?api-version=$([VSTeamVersions]::Build)" -and
               ($Body | ConvertFrom-Json).definition.id -eq 2 -and
               ($Body | ConvertFrom-Json).queue.id -eq 3 -and
               $Body -like "*system.debug*"
            }
         }

         It 'with source branch on TFS local auth should add build' {
            ## Arrange
            $Global:PSDefaultParameterValues["*:projectName"] = 'Project'

            ## Act
            Add-VSTeamBuild -projectName project -BuildDefinitionId 2 -QueueName MyQueue -SourceBranch refs/heads/dev

            ## Assert
            # Call to queue build.
            Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               # The write-host below is great for seeing how many ways the mock is called.
               # Write-Host "Assert Mock $Uri"
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/build/builds?api-version=$([VSTeamVersions]::Build)" -and
               ($Body | ConvertFrom-Json).definition.id -eq 2 -and
               ($Body | ConvertFrom-Json).queue.id -eq 3 -and
               ($Body | ConvertFrom-Json).sourceBranch -eq 'refs/heads/dev'
            }
         }
      }
   }
}