Set-StrictMode -Version Latest

#region include
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/$sut"
#endregion

Describe 'VSTeamBuildLog' {
   Context 'Get-VSTeamBuildLog' {
      ## Arrange
      # Load the mocks to create the project name dynamic parameter
      . "$PSScriptRoot\mocks\mockProjectNameDynamicParam.ps1"
      . "$PSScriptRoot\mocks\mockProjectNameDynamicParamNoPSet.ps1"

      Mock Invoke-RestMethod { return @{
            count = 4
            value = @{ }
         }
      }

      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Build' }

      Context 'Services' {
         ## Arrange
         # Set the account to use for testing. A normal user would do this
         # using the Set-VSTeamAccount function.
         Mock _getInstance { return 'https://dev.azure.com/test' }

         It 'with build id should return full log' {
            ## Act
            Get-VSTeamBuildLog -projectName project -Id 1

            ## Assert
            Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/project/_apis/build/builds/1/logs?api-version=$(_getApiVersion Build)"
            }

            Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/project/_apis/build/builds/1/logs/3?api-version=$(_getApiVersion Build)"
            }
         }

         It 'with build id and index should return full log' {
            ## Act
            Get-VSTeamBuildLog -projectName project -Id 1 -Index 2

            ## Assert
            Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/project/_apis/build/builds/1/logs/2?api-version=$(_getApiVersion Build)"
            }
         }
      }

      Context 'Server' {
         ## Arrange
         Mock _useWindowsAuthenticationOnPremise { return $true }
         Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' }

         It 'with index on TFS local Auth Should return full log' {
            ## Act
            Get-VSTeamBuildLog -projectName project -Id 1 -Index 2

            ## Assert
            Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/build/builds/1/logs/2?api-version=$(_getApiVersion Build)"
            }
         }

         It 'on TFS local Auth should return full log' {
            ## Act
            Get-VSTeamBuildLog -projectName project -Id 1

            ## Assert
            Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/build/builds/1/logs?api-version=$(_getApiVersion Build)"
            }
         
            Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/build/builds/1/logs/3?api-version=$(_getApiVersion Build)"
            }
         }
      }
   }
}