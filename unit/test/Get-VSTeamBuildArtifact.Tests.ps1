Set-StrictMode -Version Latest

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Private/applyTypes.ps1"
. "$here/../../Source/Public/$sut"

Describe 'Get-VSTeamBuildArtifact' {
   # Load the mocks to create the project name dynamic parameter
   . "$PSScriptRoot\mocks\mockProjectNameDynamicParamNoPSet.ps1"

   # Set the account to use for testing. A normal user would do this
   # using the Set-VSTeamAccount function.
   Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable

   # Mock the call to Get-Projects by the dynamic parameter for ProjectName
   Mock Invoke-RestMethod { return @() } -ParameterFilter {
      $Uri -like "*_apis/projects*"
   }

   Context "Get-VSTeamBuildArtifact calls correct Url" {
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
      }

      Get-VSTeamBuildArtifact -projectName project -id 2

      It 'should return the build artifact data' {
         Assert-MockCalled Invoke-RestMethod -Exactly -Scope Context -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/project/_apis/build/builds/2/artifacts?api-version=$([VSTeamVersions]::Build)"
         }
      }
   }

   Context "Get-VSTeamBuildArtifact result without properties" {
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
      }

      Get-VSTeamBuildArtifact -projectName project -id 2

      It 'should return the build artifact data' {
         Assert-MockCalled Invoke-RestMethod -Exactly -Scope Context -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/project/_apis/build/builds/2/artifacts?api-version=$([VSTeamVersions]::Build)"
         }
      }
   }
}

Describe 'Get-VSTeamBuildArtifact' {
   . "$PSScriptRoot\mocks\mockProjectNameDynamicParam.ps1"

   Mock _useWindowsAuthenticationOnPremise { return $true }

   # Mock the call to Get-Projects by the dynamic parameter for ProjectName
   Mock Invoke-RestMethod { return @() } -ParameterFilter {
      $Uri -like "*_apis/projects*"
   }

   Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' } -Verifiable

   Context "Get-VSTeamBuildArtifact calls correct Url on TFS local Auth" {
      Mock Invoke-RestMethod {
         return [PSCustomObject]@{
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
      }

      Get-VSTeamBuildArtifact -projectName project -id 2

      It 'should return the build artifact data' {
         Assert-MockCalled Invoke-RestMethod -Exactly -Scope Context -Times 1 -ParameterFilter {
            $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/build/builds/2/artifacts?api-version=$([VSTeamVersions]::Build)"
         }
      }
   }
}