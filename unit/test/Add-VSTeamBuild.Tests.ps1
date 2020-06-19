Set-StrictMode -Version Latest

Describe 'VSTeamBuild' {
   BeforeAll {
      Import-Module SHiPS

      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

      . "$PSScriptRoot/../../Source/Classes/VSTeamLeaf.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamDirectory.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProjectCache.ps1"
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
      . "$PSScriptRoot/../../Source/Classes/ProjectCompleter.ps1"
      . "$PSScriptRoot/../../Source/Classes/TeamQueueCompleter.ps1"
      . "$PSScriptRoot/../../Source/Classes/BuildDefinitionCompleter.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectValidateAttribute.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Private/applyTypes.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamQueue.ps1"
      . "$PSScriptRoot/../../Source/Public/Remove-VSTeamAccount.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamBuildDefinition.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"
   }

   Context 'Add-VSTeamBuild' -Tag "Add" {
      ## Arrange
      BeforeAll {
         $resultsVSTS = Get-Content "$PSScriptRoot\sampleFiles\buildDefvsts.json" -Raw | ConvertFrom-Json
         $singleResult = Get-Content "$PSScriptRoot\sampleFiles\buildSingleResult.json" -Raw | ConvertFrom-Json

         Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Build' }
      }

      Context 'Services' -Tag "Services" {
         BeforeAll {
            # Set the account to use for testing. A normal user would do this
            # using the Set-VSTeamAccount function.
            Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable

            Mock Invoke-RestMethod { return $singleResult }
            Mock Get-VSTeamBuildDefinition { return $resultsVSTS.value }
         }

         It 'by name should add build' {
            ## Act
            Add-VSTeamBuild -ProjectName project -BuildDefinitionName 'aspdemo-CI'

            ## Assert
            # Call to queue build.
            Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Body -like "*699*" -and
               $Uri -eq "https://dev.azure.com/test/project/_apis/build/builds?api-version=$(_getApiVersion Build)"
            }
         }

         It 'by id should add build' {
            ## Act
            Add-VSTeamBuild -ProjectName project -BuildDefinitionId 2

            ## Assert
            # Call to queue build.
            Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Body -like "*2*" -and
               $Uri -eq "https://dev.azure.com/test/project/_apis/build/builds?api-version=$(_getApiVersion Build)"
            }
         }

         It 'with source branch should add build' {
            ## Act
            Add-VSTeamBuild -ProjectName project -BuildDefinitionId 2 -SourceBranch 'refs/heads/dev'

            ## Assert
            # Call to queue build.
            Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Body -like "*2*" -and
               $Body -like "*refs/heads/dev*" -and
               $Uri -eq "https://dev.azure.com/test/project/_apis/build/builds?api-version=$(_getApiVersion Build)"
            }
         }

         It 'with parameters should add build' {
            ## Act
            Add-VSTeamBuild -ProjectName project -BuildDefinitionId 2 -BuildParameters @{'system.debug' = 'true' }

            ## Assert
            # Call to queue build.
            Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Body -like "*2*" -and
               $Body -like "*true*" -and
               $Uri -eq "https://dev.azure.com/test/project/_apis/build/builds?api-version=$(_getApiVersion Build)"
            }
         }
      }

      Context 'Server' -Tag "Server" {
         BeforeAll {
            ## Arrange
            Mock _useWindowsAuthenticationOnPremise { return $true }
            Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' } -Verifiable

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
         }

         It 'by id on TFS local Auth should add build' {
            ## Act
            Add-VSTeamBuild -projectName project -BuildDefinitionId 2 -QueueName MyQueue

            ## Assert
            # Call to queue build.
            Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/build/builds?api-version=$(_getApiVersion Build)" -and
               $Body -like "*2*" -and
               $Body -like "*3*"
            }
         }

         It 'with parameters on TFS local Auth should add build' {
            ## Act
            Add-VSTeamBuild -projectName project -BuildDefinitionId 2 -QueueName MyQueue -BuildParameters @{'system.debug' = 'true' }

            ## Assert
            # Call to queue build.
            Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/build/builds?api-version=$(_getApiVersion Build)" -and
               $Body -like "*2*" -and
               $Body -like "*3*" -and
               $Body -like "*system.debug*"
            }
         }

         It 'with source branch on TFS local auth should add build' {
            ## Act
            Add-VSTeamBuild -projectName project -BuildDefinitionId 2 -QueueName MyQueue -SourceBranch refs/heads/dev

            ## Assert
            # Call to queue build.
            Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/build/builds?api-version=$(_getApiVersion Build)" -and
               $Body -like "*2*" -and
               $Body -like "*3*" -and
               $Body -like "*refs/heads/dev*"
            }
         }
      }
   }
}