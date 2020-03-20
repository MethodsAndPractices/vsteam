Set-StrictMode -Version Latest

#region include
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Private/applyTypes.ps1"
. "$here/../../Source/Public/$sut"
. "$here/../../Source/Public/Remove-VSTeamAccount.ps1"
#endregion

Describe 'VSTeamBuild' {
   ## Arrange
   # Sample result of a single build
   $singleResult = Get-Content "$PSScriptRoot\sampleFiles\buildSingleResult.json" -Raw | ConvertFrom-Json

   # Sample result for list of builds
   $results = Get-Content "$PSScriptRoot\sampleFiles\buildResults.json" -Raw | ConvertFrom-Json

   # Load the mocks to create the project name dynamic parameter
   . "$PSScriptRoot\mocks\mockProjectNameDynamicParam.ps1"
   . "$PSScriptRoot\mocks\mockProjectNameDynamicParamNoPSet.ps1"

   Mock Invoke-RestMethod { return $results }
   Mock Invoke-RestMethod { return $singleResult } -ParameterFilter { $Uri -like "*101*" }

   Context 'Get-VSTeamBuild' {
      Context 'Services' {
         ## Arrange
         # Set the account to use for testing. A normal user would do this
         # using the Set-VSTeamAccount function.
         Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable

         It 'with no parameters should return builds' {
            ## Act
            Get-VSTeamBuild -projectName project

            ## Assert
            Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/project/_apis/build/builds?api-version=$([VSTeamVersions]::Build)"
            }
         }

         It 'with Top parameter should return top builds' {
            ## Act
            Get-VSTeamBuild -projectName project -top 1

            ## Assert
            Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/project/_apis/build/builds?api-version=$([VSTeamVersions]::Build)&`$top=1"
            }
         }

         It 'by id should return top builds' {
            ## Act
            Get-VSTeamBuild -projectName project -id 101

            ## Assert
            Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/project/_apis/build/builds/101?api-version=$([VSTeamVersions]::Build)"
            }
         }
      }

      Context 'Server' {
         ## Arrange
         Mock _useWindowsAuthenticationOnPremise { return $true }
         Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' } -Verifiable

         It 'with no parameters on TFS local Auth should return builds' {
            ## Act
            Get-VSTeamBuild -projectName project

            ## Assert
            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/build/builds?api-version=$([VSTeamVersions]::Build)"
            }
         }

         It 'should return builds' {
            ## Act
            Get-VSTeamBuild -projectName project -id 101

            ## Assert
            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter { $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/build/builds/101?api-version=$([VSTeamVersions]::Build)" }
         }
      }
   }
}