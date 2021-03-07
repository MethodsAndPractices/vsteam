Set-StrictMode -Version Latest

Describe 'VSTeamBuildArtifact' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
   }

   Context "Get-VSTeamBuildArtifact" {
      BeforeAll {
         ## Arrange
         # Set the account to use for testing. A normal user would do this
         # using the Set-VSTeamAccount function.
         Mock _getInstance { return 'https://dev.azure.com/test' }
         Mock Invoke-RestMethod { Open-SampleFile 'Get-VSTeamBuildArtifact-Id568.json' }
         Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Build' }
      }

      Context "Services" {
         It 'should return the build artifact data' {
            ## Act
            Get-VSTeamBuildArtifact -projectName project -id 1

            ## Assert
            Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/project/_apis/build/builds/1/artifacts?api-version=$(_getApiVersion Build)"
            }
         }
      }

      Context 'Server' {
         BeforeAll {
            ## Arrange
            Mock _useWindowsAuthenticationOnPremise { return $true }
            Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' }
         }
         It 'should return the build artifact data calls correct Url on TFS local Auth' {
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