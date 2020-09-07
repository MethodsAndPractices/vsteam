Set-StrictMode -Version Latest

Describe 'VSTeamBuildDefinition' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
   }
      
   Context 'Add-VSTeamBuildDefinition' {
      ## Arrange
      BeforeAll {
         Mock Invoke-RestMethod { Open-SampleFile 'buildDefvsts.json' }
         Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Build' }
      }

      Context 'Services' -Tag "Services" {
         ## Arrange
         BeforeAll {
            Mock _getInstance { return 'https://dev.azure.com/test' }
         }

         it 'Should add build' {
            ## Act
            Add-VSTeamBuildDefinition -projectName project `
               -inFile 'sampleFiles/builddef.json'

            ## Assert
            Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Method -eq 'Post' -and
               $InFile -eq 'sampleFiles/builddef.json' -and
               $Uri -eq "https://dev.azure.com/test/project/_apis/build/definitions?api-version=$(_getApiVersion Build)"
            }
         }
      }

      Context 'Server' -Tag "Server" {
         ## Arrange
         BeforeAll {
            Mock _useWindowsAuthenticationOnPremise { return $true }
            Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' }
         }

         it 'Should add build' {
            ## Act
            Add-VSTeamBuildDefinition -projectName project `
               -inFile 'sampleFiles/builddef.json'

            ## Assert
            Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Method -eq 'Post' -and
               $InFile -eq 'sampleFiles/builddef.json' -and
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/build/definitions?api-version=$(_getApiVersion Build)"
            }
         }
      }
   }
}