Set-StrictMode -Version Latest

# Loading System.Web avoids issues finding System.Web.HttpUtility
Add-Type -AssemblyName 'System.Web'

InModuleScope VSTeam {
   $resultsVSTS = Get-Content "$PSScriptRoot\sampleFiles\buildDefvsts.json" -Raw | ConvertFrom-Json
   $resultsAzD = Get-Content "$PSScriptRoot\sampleFiles\buildDefAzD.json" -Raw | ConvertFrom-Json
   $results2017 = Get-Content "$PSScriptRoot\sampleFiles\buildDef2017.json" -Raw | ConvertFrom-Json
   $results2018 = Get-Content "$PSScriptRoot\sampleFiles\buildDef2018.json" -Raw | ConvertFrom-Json

   Describe 'BuildDefinitions' {
      # Mock the call to Get-Projects by the dynamic parameter for ProjectName
      Mock Invoke-RestMethod { return @() } -ParameterFilter {
         $Uri -like "*_apis/projects*"
      }

      . "$PSScriptRoot\mocks\mockProjectNameDynamicParamNoPSet.ps1"

      Context 'Get-VSTeamBuildDefinition with no parameters 2017' {
         Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' } -Verifiable

         Mock _useWindowsAuthenticationOnPremise { return $true }
         Mock Invoke-RestMethod {
            # If this test fails uncomment the line below to see how the mock was called.
            # Write-Host $args
            # Write-Host $([VSTeamVersions]::Build)
            # Write-Host $([VSTeamVersions]::Account)

            return $results2017
         }

         It 'should return build definitions' {
            Get-VSTeamBuildDefinition -projectName project

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -like "*http://localhost:8080/tfs/defaultcollection/project/_apis/build/definitions*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Build)*" -and
               $Uri -like "*type=All*"
            }
         }
      }

      Context 'Get-VSTeamBuildDefinition with no parameters 2018' {
         Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' } -Verifiable

         Mock _useWindowsAuthenticationOnPremise { return $true }
         Mock Invoke-RestMethod {
            return $results2018
         }

         It 'should return build definitions' {
            Get-VSTeamBuildDefinition -projectName project

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -like "*http://localhost:8080/tfs/defaultcollection/project/_apis/build/definitions*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Build)*" -and
               $Uri -like "*type=All*"
            }
         }
      }

      Context 'Get-VSTeamBuildDefinition with no parameters AzD v5.0 of API' {
         Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable

         Mock Invoke-RestMethod {
            return $resultsAzD
         }

         It 'should return build definitions' {
            Get-VSTeamBuildDefinition -projectName project

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -like "*https://dev.azure.com/test/project/_apis/build/definitions*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Build)*" -and
               $Uri -like "*type=All*"
            }
         }
      }

      Context 'Get-VSTeamBuildDefinition with no parameters VSTS' {
         Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable

         Mock Invoke-RestMethod {
            return $resultsVSTS
         }

         It 'should return build definitions' {
            Get-VSTeamBuildDefinition -projectName project

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -like "*https://dev.azure.com/test/project/_apis/build/definitions*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Build)*" -and
               $Uri -like "*type=All*"
            }
         }
      }

      Context 'Get-VSTeamBuildDefinition with no parameters VSTS yaml ' {
         Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable

         Mock Invoke-RestMethod {
            return $resultsVSTS
         }

         It 'should return build definitions' {
            Get-VSTeamBuildDefinition -projectName project

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -like "*https://dev.azure.com/test/project/_apis/build/definitions*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Build)*" -and
               $Uri -like "*type=All*"
            }
         }
      }

      Context 'Get-VSTeamBuildDefinition with type parameter' {
         Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable

         Mock Invoke-RestMethod {
            return $resultsVSTS
         }

         It 'should return build definitions by type' {
            Get-VSTeamBuildDefinition -projectName project -type build

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -like "*https://dev.azure.com/test/project/_apis/build/definitions*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Build)*" -and
               $Uri -like "*type=build*"
            }
         }
      }

      Context 'Get-VSTeamBuildDefinition with filter parameter' {
         Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable

         Mock Invoke-RestMethod { return $resultsVSTS }

         It 'should return build definitions by filter' {
            Get-VSTeamBuildDefinition -projectName project -filter 'click*'

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -like "*https://dev.azure.com/test/project/_apis/build/definitions*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Build)*" -and
               $Uri -like "*name=click*" -and
               $Uri -like "*type=All*"
            }
         }
      }

      Context 'Get-VSTeamBuildDefinition with both parameters' {
         Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable

         Mock Invoke-RestMethod { return $resultsVSTS }

         It 'should return build definitions by filter' {
            Get-VSTeamBuildDefinition -projectName project -filter 'click*' -type build

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -like "*https://dev.azure.com/test/project/_apis/build/definitions*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Build)*" -and
               $Uri -like "*name=click*" -and
               $Uri -like "*type=build*"
            }
         }
      }

      Context 'Get-VSTeamBuildDefinition by ID' {
         Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable

         Mock Invoke-RestMethod { return $resultsVSTS.value }

         It 'should return build definition' {
            $b = Get-VSTeamBuildDefinition -projectName project -id 15

            $b | Get-Member | Select-Object -First 1 -ExpandProperty TypeName | Should be 'Team.BuildDefinition'

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/project/_apis/build/definitions/15?api-version=$([VSTeamVersions]::Build)"
            }
         }
      }

      Context 'Get-VSTeamBuildDefinition by ID -Raw' {
         Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable

         Mock Invoke-RestMethod { return $resultsVSTS.value }

         It 'should return build definition' {
            $raw = Get-VSTeamBuildDefinition -projectName project -id 15 -Raw

            $raw | Get-Member | Select-Object -First 1 -ExpandProperty TypeName | Should be 'System.Management.Automation.PSCustomObject'

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/project/_apis/build/definitions/15?api-version=$([VSTeamVersions]::Build)"
            }
         }
      }

      Context 'Get-VSTeamBuildDefinition by ID -Json' {
         Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable

         Mock Invoke-RestMethod { return $resultsVSTS.value }

         It 'should return build definition' {
            $b = Get-VSTeamBuildDefinition -projectName project -id 15 -Json

            $b | Get-Member | Select-Object -First 1 -ExpandProperty TypeName | Should be 'System.String'

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/project/_apis/build/definitions/15?api-version=$([VSTeamVersions]::Build)"
            }
         }
      }

      Context 'Get-VSTeamBuildDefinition by ID local auth' {
         Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' } -Verifiable

         Mock _useWindowsAuthenticationOnPremise { return $true }
         Mock Invoke-RestMethod { return $resultsVSTS.value }

         It 'should return build definition' {
            Get-VSTeamBuildDefinition -projectName project -id 15

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/build/definitions/15?api-version=$([VSTeamVersions]::Build)"
            }
         }
      }

      Context 'Get-VSTeamBuildDefinition with revision parameter' {
         Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable

         Mock Invoke-RestMethod { return $resultsVSTS.value }

         It 'should return build definitions by revision' {
            Get-VSTeamBuildDefinition -projectName project -id 16 -revision 1

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/project/_apis/build/definitions/16?api-version=$([VSTeamVersions]::Build)&revision=1"
            }
         }
      }

      # Make sure these test run last as the need differnt
      # [VSTeamVersions]::Account values
      Context 'Get-VSTeamBuildDefinition with no account' {
         [VSTeamVersions]::Account = $null

         It 'should return build definitions' {
            { Get-VSTeamBuildDefinition -projectName project } | Should Throw
         }
      }
   }
}