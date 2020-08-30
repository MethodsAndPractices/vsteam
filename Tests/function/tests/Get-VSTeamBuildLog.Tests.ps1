Set-StrictMode -Version Latest

Describe 'VSTeamBuildLog' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
   }

   Context 'Get-VSTeamBuildLog' {
      BeforeAll {
         ## Arrange
         Mock Invoke-RestMethod { return @{
               count = 4
               value = @{ }
            }
         }

         # Make sure the project name is valid. By returning an empty array
         # all project names are valid. Otherwise, you name you pass for the
         # project in your commands must appear in the list.
         Mock Invoke-RestMethod { return @() } -ParameterFilter {
            $Uri -like "*`$top=100*" -and
            $Uri -like "*stateFilter=WellFormed*"
         }

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
               $Uri -eq "https://dev.azure.com/test/project/_apis/build/builds/1/logs/3?api-version=$(_getApiVersion Build)"
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
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/build/builds/1/logs/3?api-version=$(_getApiVersion Build)"
            }
         }
      }
   }
}