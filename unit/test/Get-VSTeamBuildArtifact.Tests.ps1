Set-StrictMode -Version Latest

Describe 'VSTeamBuildArtifact' {
   BeforeAll {
      Import-Module SHiPS
      Add-Type -Path "$PSScriptRoot/../../dist/bin/vsteam-lib.dll"
   
      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

      . "$PSScriptRoot/../../Source/Classes/VSTeamLeaf.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamDirectory.ps1"
      
      . "$PSScriptRoot/../../Source/Classes/VSTeamUserEntitlement.ps1"
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
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Private/applyTypes.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamProject.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"

      # Make sure the project name is valid. By returning an empty array
      # all project names are valid. Otherwise, you name you pass for the
      # project in your commands must appear in the list.
      # Get-VSTeamProject for cache
      Mock Invoke-RestMethod { return @() } -ParameterFilter {
         $Uri -like "*https://dev.azure.com/test/_apis/projects*" -and
         $Uri -like "*api-version=$(_getApiVersion Core)*" -and
         $Uri -like "*`$top=100*" -and
         $Uri -like "*stateFilter=WellFormed*"
      }
   }

   Context "Get-VSTeamBuildArtifact" {
      BeforeAll {
         ## Arrange
         # Set the account to use for testing. A normal user would do this
         # using the Set-VSTeamAccount function.
         Mock _getInstance { return 'https://dev.azure.com/test' }
         Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Build' }

         Mock Invoke-RestMethod { return [PSCustomObject]@{
               value = [PSCustomObject]@{
                  id       = 150
                  name     = "Drop"
                  resource = [PSCustomObject]@{
                     type       = "filepath"
                     data       = "C:\Test"
                     properties = [PSCustomObject]@{ }
                  }
               }
            }
         } -ParameterFilter {
            $Uri -like "*builds/1*"
         }

         Mock Invoke-RestMethod { return [PSCustomObject]@{
               value = [PSCustomObject]@{
                  id       = 150
                  name     = "Drop"
                  resource = [PSCustomObject]@{
                     type = "filepath"
                     data = "C:\Test"
                  }
               }
            }
         } -ParameterFilter {
            $Uri -like "*2*"
         }
      }
      Context "Services" {
         It 'calls correct Url should return the build artifact data' {
            ## Act
            Get-VSTeamBuildArtifact -projectName project -id 1

            ## Assert
            Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/project/_apis/build/builds/1/artifacts?api-version=$(_getApiVersion Build)"
            }
         }

         It 'result without properties should return the build artifact data' {
            ## Act
            Get-VSTeamBuildArtifact -projectName project -id 2

            ## Assert
            Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/project/_apis/build/builds/2/artifacts?api-version=$(_getApiVersion Build)"
            }
         }
      }

      Context 'Server' {
         BeforeAll {
            ## Arrange
            Mock _useWindowsAuthenticationOnPremise { return $true }
            Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' }
         }
         It 'calls correct Url on TFS local Auth should return the build artifact data' {
            ## Act
            Get-VSTeamBuildArtifact -projectName project -id 1

            ## Assert
            Should -Invoke Invoke-RestMethod -Exactly -Scope Context -Times 1 -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/build/builds/1/artifacts?api-version=$(_getApiVersion Build)"
            }
         }
      }
   }
}