Set-StrictMode -Version Latest

Describe 'VSTeamBuildLog' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
   }

   Context 'Get-VSTeamBuildLog' {
      BeforeAll {
         ## Arrange
         Mock Invoke-RestMethod { Open-SampleFile 'Get-VSTeamBuildLog-Id568.json' }
         Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Build' }
      }

      Context 'Services' {
         BeforeAll {
            ## Arrange
            # Set the account to use for testing. A normal user would do this
            # using the Set-VSTeamAccount function.
            Mock _getInstance { return 'https://dev.azure.com/test' }
         }

         It 'with build id should return full log' {
            ## Act
            Get-VSTeamBuildLog -projectName project -Id 1

            ## Assert
            Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/project/_apis/build/builds/1/logs?api-version=$(_getApiVersion Build)"
            }

            Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/project/_apis/build/builds/1/logs/61?api-version=$(_getApiVersion Build)"
            }
         }

         It 'with build id and index should return full log' {
            ## Act
            Get-VSTeamBuildLog -projectName project -Id 1 -Index 2

            ## Assert
            Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/project/_apis/build/builds/1/logs/2?api-version=$(_getApiVersion Build)"
            }
         }
      }

      Context 'Server' {
         BeforeAll {
            ## Arrange
            Mock _useWindowsAuthenticationOnPremise { return $true }
            Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' }
         }

         It 'with index on TFS local Auth Should return full log' {
            ## Act
            Get-VSTeamBuildLog -projectName project -Id 1 -Index 2

            ## Assert
            Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/build/builds/1/logs/2?api-version=$(_getApiVersion Build)"
            }
         }

         It 'on TFS local Auth should return full log' {
            ## Act
            Get-VSTeamBuildLog -projectName project -Id 1

            ## Assert
            Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/build/builds/1/logs?api-version=$(_getApiVersion Build)"
            }

            Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/build/builds/1/logs/61?api-version=$(_getApiVersion Build)"
            }
         }
      }
   }
}