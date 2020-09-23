Set-StrictMode -Version Latest

Describe 'VSTeamBuildDefinition' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
   }

   Context 'Get-VSTeamBuildDefinition' {
      BeforeAll {
         Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Build' }
         Mock Invoke-RestMethod { Open-SampleFile 'buildDefAzD.json' } -ParameterFilter { $Uri -like "*azd*" }
         Mock Invoke-RestMethod { Open-SampleFile 'buildDefvsts.json' } -ParameterFilter { $Uri -like "*vsts*" }
         Mock Invoke-RestMethod { Open-SampleFile 'buildDef2017.json' } -ParameterFilter { $Uri -like "*2017Project*" }
         Mock Invoke-RestMethod { Open-SampleFile 'buildDef2018.json' } -ParameterFilter { $Uri -like "*2018Project*" }
         Mock Invoke-RestMethod { Open-SampleFile 'buildDefvsts.json' -ReturnValue } -ParameterFilter { $Uri -like "*101*" }
      }

      Context 'Server' {
         BeforeAll {
            Mock _useWindowsAuthenticationOnPremise { return $true }
            Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' }
         }

         It 'TFS 2017 with no parameters should return build definitions' {
            ## Act
            Get-VSTeamBuildDefinition -projectName "2017Project"

            ## Assert
            Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Uri -like "*http://localhost:8080/tfs/defaultcollection/2017Project/_apis/build/definitions*" -and
               $Uri -like "*api-version=$(_getApiVersion Build)*"
            }
         }

         It 'TFS 2018 with no parameters should return build definitions' {
            ## Act
            Get-VSTeamBuildDefinition -projectName "2018Project"

            ## Assert
            Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Uri -like "*http://localhost:8080/tfs/defaultcollection/2018Project/_apis/build/definitions*" -and
               $Uri -like "*api-version=$(_getApiVersion Build)*"
            }
         }

         It 'by ID local auth should return build definition' {
            ## Act
            Get-VSTeamBuildDefinition -projectName project -id 101

            ## Assert
            Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/build/definitions/101?api-version=$(_getApiVersion Build)"
            }
         }
      }

      Context 'Services' {
         BeforeAll {
            ## Arrange
            Mock _getInstance { return 'https://dev.azure.com/test' }
         }

         It 'AzD v5.0 of API with no parameters should return build definitions' {
            ## Act
            Get-VSTeamBuildDefinition -projectName azd

            ## Assert
            Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Uri -like "*https://dev.azure.com/test/azd/_apis/build/definitions*" -and
               $Uri -like "*api-version=$(_getApiVersion Build)*"
            }
         }

         It 'should return build definitions' {
            ## Act
            Get-VSTeamBuildDefinition -projectName vsts

            ## Assert
            Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Uri -like "*https://dev.azure.com/test/vsts/_apis/build/definitions*" -and
               $Uri -like "*api-version=$(_getApiVersion Build)*"
            }
         }

         It 'with type parameter "build" should return build definitions by type' {
            ## Arrange
            # This has not been supported since version 2.0 of the API which we
            # no longer support. https://github.com/MethodsAndPractices/vsteam/issues/87
            Mock Write-Warning

            ## Act
            Get-VSTeamBuildDefinition -projectName vsts

            ## Assert
            Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -like "*https://dev.azure.com/test/vsts/_apis/build/definitions*" -and
               $Uri -like "*api-version=$(_getApiVersion Build)*"
            }
         }

         It 'with filter parameter should return build definitions by filter' {
            ## Act
            Get-VSTeamBuildDefinition -projectName vsts -filter 'click*'

            ## Assert
            Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -like "*https://dev.azure.com/test/vsts/_apis/build/definitions*" -and
               $Uri -like "*api-version=$(_getApiVersion Build)*" -and
               $Uri -like "*name=click*"
            }
         }

         It 'with both parameters should return build definitions by filter' {
            ## Arrange
            # This has not been supported since version 2.0 of the API which we
            # no longer support. https://github.com/MethodsAndPractices/vsteam/issues/87
            Mock Write-Warning

            ## Act
            Get-VSTeamBuildDefinition -projectName vsts -filter 'click*'

            ## Asset
            Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -like "*https://dev.azure.com/test/vsts/_apis/build/definitions*" -and
               $Uri -like "*api-version=$(_getApiVersion Build)*" -and
               $Uri -like "*name=click*"
            }
         }

         It 'by id should return build definition' {
            ## Act
            $b = Get-VSTeamBuildDefinition -projectName project -id 101

            ## Assert
            $b | Get-Member | Select-Object -First 1 -ExpandProperty TypeName | Should -Be 'vsteam_lib.BuildDefinition'

            Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/project/_apis/build/definitions/101?api-version=$(_getApiVersion Build)"
            }
         }

         It 'by ID -Raw should return build definition' {
            ## Act
            $raw = Get-VSTeamBuildDefinition -projectName project -id 101 -Raw

            ## Assert
            $raw | Get-Member | Select-Object -First 1 -ExpandProperty TypeName | Should -Be 'System.Management.Automation.PSCustomObject'

            Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/project/_apis/build/definitions/101?api-version=$(_getApiVersion Build)"
            }
         }

         It 'by ID -Json should return build definition' {
            ## Act
            $b = Get-VSTeamBuildDefinition -projectName project -id 101 -Json

            ## Assert
            $b | Get-Member | Select-Object -First 1 -ExpandProperty TypeName | Should -Be 'System.String'

            Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/project/_apis/build/definitions/101?api-version=$(_getApiVersion Build)"
            }
         }

         It 'with revision parameter should return build definitions by revision' {
            ## Act
            Get-VSTeamBuildDefinition -projectName project -id 101 -revision 1

            ## Assert
            Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/project/_apis/build/definitions/101?api-version=$(_getApiVersion Build)&revision=1"
            }
         }
      }
   }
}