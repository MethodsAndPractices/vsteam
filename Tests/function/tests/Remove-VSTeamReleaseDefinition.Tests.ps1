Set-StrictMode -Version Latest

Describe 'VSTeamReleaseDefinition' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      
      ## Arrange
      Mock _getApiVersion { return '1.0-unittest' } -ParameterFilter { $Service -eq 'Release' }
   }

   Context 'Remove-VSTeamReleaseDefinition' {
      BeforeAll {
         Mock Invoke-RestMethod { Open-SampleFile 'Get-VSTeamReleaseDefinition.json' }
      }

      Context 'Services' {
         BeforeAll {
            Mock _getInstance { return 'https://dev.azure.com/test' }
         }

         It 'should delete release definition' {
            ## Act
            Remove-VSTeamReleaseDefinition -projectName project -id 2 -Force

            ## Assert
            Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Method -eq 'Delete' -and
               $Uri -eq "https://vsrm.dev.azure.com/test/project/_apis/release/definitions/2?api-version=$(_getApiVersion Release)"
            }
         }
      }

      Context 'Server' {
         BeforeAll {
            Mock _useWindowsAuthenticationOnPremise { return $true }
            Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' }
         }

         It 'local Auth should delete release definition' {
            ## Act
            Remove-VSTeamReleaseDefinition -projectName project -id 2 -Force

            ## Assert
            Should -Invoke Invoke-RestMethod -Exactly -Scope Context -Times 1 -ParameterFilter {
               $Method -eq 'Delete' -and
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/release/definitions/2?api-version=$(_getApiVersion Release)"
            }
         }
      }
   }
}