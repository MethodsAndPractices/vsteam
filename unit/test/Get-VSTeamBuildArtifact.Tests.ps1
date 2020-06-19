Set-StrictMode -Version Latest

BeforeAll {
   $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

   . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
   . "$PSScriptRoot/../../Source/Classes/VSTeamProjectCache.ps1"
   . "$PSScriptRoot/../../Source/Classes/ProjectCompleter.ps1"
   . "$PSScriptRoot/../../Source/Classes/ProjectValidateAttribute.ps1"
   . "$PSScriptRoot/../../Source/Private/common.ps1"
   . "$PSScriptRoot/../../Source/Private/applyTypes.ps1"
   . "$PSScriptRoot/../../Source/Public/$sut"
}

Describe 'VSTeamBuildArtifact' {
   BeforeAll {
      # Make sure the project name is valid. By returning an empty array
      # all project names are valid. Otherwise, you name you pass for the
      # project in your commands must appear in the list.
      Mock _getProjects { return @() }
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
            $Uri -like "*1*"
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