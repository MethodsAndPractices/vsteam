Set-StrictMode -Version Latest

# Loading System.Web avoids issues finding System.Web.HttpUtility
Add-Type -AssemblyName 'System.Web'

InModuleScope VSTeam {
   [VSTeamVersions]::Account = 'https://dev.azure.com/test'

   $resultsVSTS = Get-Content "$PSScriptRoot\sampleFiles\buildDefvsts.json" -Raw | ConvertFrom-Json
   $resultsAzD = Get-Content "$PSScriptRoot\sampleFiles\buildDefAzD.json" -Raw | ConvertFrom-Json
   $results2017 = Get-Content "$PSScriptRoot\sampleFiles\buildDef2017.json" -Raw | ConvertFrom-Json
   $results2018 = Get-Content "$PSScriptRoot\sampleFiles\buildDef2018.json" -Raw | ConvertFrom-Json
   $resultsyaml = Get-Content "$PSScriptRoot\sampleFiles\buildDefyaml.json" -Raw | ConvertFrom-Json

   Describe 'BuildDefinitions' {
      # Mock the call to Get-Projects by the dynamic parameter for ProjectName
      Mock Invoke-RestMethod { return @() } -ParameterFilter {
         $Uri -like "*_apis/projects*"
      }

      . "$PSScriptRoot\mocks\mockProjectNameDynamicParamNoPSet.ps1"

      Context 'Show-VSTeamBuildDefinition by ID' {
         Mock Show-Browser { }

         it 'should return url for mine' {
            Show-VSTeamBuildDefinition -projectName project -Id 15

            Assert-MockCalled Show-Browser -Exactly -Scope It -Times 1 -ParameterFilter {
               $url -eq 'https://dev.azure.com/test/project/_build/index?definitionId=15'
            }
         }
      }

      Context 'Show-VSTeamBuildDefinition Mine' {
         Mock Show-Browser { }

         it 'should return url for mine' {
            Show-VSTeamBuildDefinition -projectName project -Type Mine

            Assert-MockCalled Show-Browser -Exactly -Scope It -Times 1 -ParameterFilter {
               $url -eq 'https://dev.azure.com/test/project/_build/index?_a=mine&path=%5c'
            }
         }
      }

      Context 'Show-VSTeamBuildDefinition XAML' {
         Mock Show-Browser { }

         it 'should return url for XAML' {
            Show-VSTeamBuildDefinition -projectName project -Type XAML

            Assert-MockCalled Show-Browser -Exactly -Scope It -Times 1 -ParameterFilter {
               $url -eq 'https://dev.azure.com/test/project/_build/xaml&path=%5c'
            }
         }
      }

      Context 'Show-VSTeamBuildDefinition Queued' {
         Mock Show-Browser { }

         it 'should return url for Queued' {
            Show-VSTeamBuildDefinition -projectName project -Type Queued

            Assert-MockCalled Show-Browser -Exactly -Scope It -Times 1 -ParameterFilter {
               $url -eq 'https://dev.azure.com/test/project/_build/index?_a=queued&path=%5c'
            }
         }
      }

      Context 'Show-VSTeamBuildDefinition Mine with path' {
         Mock Show-Browser { }

         it 'should return url for mine' {
            Show-VSTeamBuildDefinition -projectName project -path '\test'

            Assert-MockCalled Show-Browser -Exactly -Scope It -Times 1 -ParameterFilter {
               $url -like 'https://dev.azure.com/test/project/_Build/index?_a=allDefinitions&path=%5Ctest'
            }
         }
      }

      Context 'Show-VSTeamBuildDefinition Mine with path missing \' {
         Mock Show-Browser { }

         it 'should return url for mine with \ added' {
            Show-VSTeamBuildDefinition -projectName project -path 'test'

            Assert-MockCalled Show-Browser -Exactly -Scope It -Times 1 -ParameterFilter {
               $url -like 'https://dev.azure.com/test/project/_Build/index?_a=allDefinitions&path=%5Ctest'
            }
         }
      }

      Context 'Get-VSTeamBuildDefinition with no parameters 2017' {
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
               $Uri -like "*https://dev.azure.com/test/project/_apis/build/definitions/*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Build)*" -and
               $Uri -like "*type=All*"
            }
         }
      }

      Context 'Get-VSTeamBuildDefinition with no parameters 2018' {
         Mock _useWindowsAuthenticationOnPremise { return $true }
         Mock Invoke-RestMethod {
            return $results2018
         }

         It 'should return build definitions' {
            Get-VSTeamBuildDefinition -projectName project

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -like "*https://dev.azure.com/test/project/_apis/build/definitions/*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Build)*" -and
               $Uri -like "*type=All*"
            }
         }
      }

      Context 'Get-VSTeamBuildDefinition with no parameters AzD v5.0 of API' {
         Mock Invoke-RestMethod {
            return $resultsAzD
         }

         It 'should return build definitions' {
            Get-VSTeamBuildDefinition -projectName project

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -like "*https://dev.azure.com/test/project/_apis/build/definitions/*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Build)*" -and
               $Uri -like "*type=All*"
            }
         }
      }

      Context 'Get-VSTeamBuildDefinition with no parameters VSTS' {
         Mock Invoke-RestMethod {
            return $resultsVSTS
         }

         It 'should return build definitions' {
            Get-VSTeamBuildDefinition -projectName project

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -like "*https://dev.azure.com/test/project/_apis/build/definitions/*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Build)*" -and
               $Uri -like "*type=All*"
            }
         }
      }

      Context 'Get-VSTeamBuildDefinition with no parameters VSTS yaml ' {
         Mock Invoke-RestMethod {
            return $resultsVSTS
         }

         It 'should return build definitions' {
            Get-VSTeamBuildDefinition -projectName project

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -like "*https://dev.azure.com/test/project/_apis/build/definitions/*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Build)*" -and
               $Uri -like "*type=All*"
            }
         }
      }

      Context 'Get-VSTeamBuildDefinition with type parameter' {
         Mock Invoke-RestMethod {
            return $resultsVSTS
         }

         It 'should return build definitions by type' {
            Get-VSTeamBuildDefinition -projectName project -type build

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -like "*https://dev.azure.com/test/project/_apis/build/definitions/*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Build)*" -and
               $Uri -like "*type=build*"
            }
         }
      }

      Context 'Get-VSTeamBuildDefinition with filter parameter' {
         Mock Invoke-RestMethod { return $resultsVSTS }

         It 'should return build definitions by filter' {
            Get-VSTeamBuildDefinition -projectName project -filter 'click*'

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -like "*https://dev.azure.com/test/project/_apis/build/definitions/*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Build)*" -and
               $Uri -like "*name=click*" -and
               $Uri -like "*type=All*"
            }
         }
      }

      Context 'Get-VSTeamBuildDefinition with both parameters' {
         Mock Invoke-RestMethod { return $resultsVSTS }

         It 'should return build definitions by filter' {
            Get-VSTeamBuildDefinition -projectName project -filter 'click*' -type build

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -like "*https://dev.azure.com/test/project/_apis/build/definitions/*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Build)*" -and
               $Uri -like "*name=click*" -and
               $Uri -like "*type=build*"
            }
         }
      }

      Context 'Add-VSTeamBuildDefinition' {
         Mock Invoke-RestMethod { return $resultsVSTS }

         it 'Should add build' {
            Add-VSTeamBuildDefinition -projectName project -inFile 'sampleFiles/builddef.json'

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Method -eq 'Post' -and
               $InFile -eq 'sampleFiles/builddef.json' -and
               $Uri -eq "https://dev.azure.com/test/project/_apis/build/definitions/?api-version=$([VSTeamVersions]::Build)"
            }
         }
      }

      Context 'Get-VSTeamBuildDefinition by ID' {
         Mock Invoke-RestMethod { return $resultsVSTS.value }

         It 'should return build definition' {
            Get-VSTeamBuildDefinition -projectName project -id 15

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/project/_apis/build/definitions/15?api-version=$([VSTeamVersions]::Build)"
            }
         }
      }

      Context 'Get-VSTeamBuildDefinition by ID local auth' {
         Mock _useWindowsAuthenticationOnPremise { return $true }
         Mock Invoke-RestMethod { return $resultsVSTS.value }

         It 'should return build definition' {
            Get-VSTeamBuildDefinition -projectName project -id 15

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/project/_apis/build/definitions/15?api-version=$([VSTeamVersions]::Build)"
            }
         }
      }

      Context 'Get-VSTeamBuildDefinition with revision parameter' {
         Mock Invoke-RestMethod { return $resultsVSTS.value }

         It 'should return build definitions by revision' {
            Get-VSTeamBuildDefinition -projectName project -id 16 -revision 1

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/project/_apis/build/definitions/16?api-version=$([VSTeamVersions]::Build)&revision=1"
            }
         }
      }

      Context 'Remove-VSTeamBuildDefinition' {
         Mock Invoke-RestMethod { return $resultsVSTS }

         It 'should delete build definition' {
            Remove-VSTeamBuildDefinition -projectName project -id 2 -Force

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Method -eq 'Delete' -and
               $Uri -eq "https://dev.azure.com/test/project/_apis/build/definitions/2?api-version=$([VSTeamVersions]::Build)"
            }
         }
      }

      Context 'Update-VSTeamBuildDefinition' {
         Mock Invoke-RestMethod { return $resultsVSTS }

         It 'should update build definition' {
            Update-VSTeamBuildDefinition -projectName project -id 2 -inFile 'sampleFiles/builddef.json' -Force

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Method -eq 'Put' -and
               $InFile -eq 'sampleFiles/builddef.json' -and
               $Uri -eq "https://dev.azure.com/test/project/_apis/build/definitions/2?api-version=$([VSTeamVersions]::Build)"
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

      Context 'Add-VSTeamBuildDefinition on TFS local Auth' {
         Mock Invoke-RestMethod { return $resultsVSTS }
         Mock _useWindowsAuthenticationOnPremise { return $true }
         [VSTeamVersions]::Account = 'http://localhost:8080/tfs/defaultcollection'

         it 'Should add build' {
            Add-VSTeamBuildDefinition -projectName project -inFile 'sampleFiles/builddef.json'

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Method -eq 'Post' -and
               $InFile -eq 'sampleFiles/builddef.json' -and
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/build/definitions/?api-version=$([VSTeamVersions]::Build)"
            }
         }
      }

      Context 'Remove-VSTeamBuildDefinition on TFS local Auth' {
         Mock Invoke-RestMethod { return $resultsVSTS }
         Mock _useWindowsAuthenticationOnPremise { return $true }
         [VSTeamVersions]::Account = 'http://localhost:8080/tfs/defaultcollection'

         Remove-VSTeamBuildDefinition -projectName project -id 2 -Force

         It 'should delete build definition' {
            Assert-MockCalled Invoke-RestMethod -Exactly -Scope Context -Times 1 -ParameterFilter {
               $Method -eq 'Delete' -and
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/build/definitions/2?api-version=$([VSTeamVersions]::Build)"
            }
         }
      }

      Context 'Update-VSTeamBuildDefinition on TFS local Auth' {
         Mock Invoke-RestMethod { return $resultsVSTS }
         Mock _useWindowsAuthenticationOnPremise { return $true }
         [VSTeamVersions]::Account = 'http://localhost:8080/tfs/defaultcollection'

         Update-VSTeamBuildDefinition -projectName project -id 2 -inFile 'sampleFiles/builddef.json' -Force

         It 'should update build definition' {
            Assert-MockCalled Invoke-RestMethod -Exactly -Scope Context -Times 1 -ParameterFilter {
               $Method -eq 'Put' -and
               $InFile -eq 'sampleFiles/builddef.json' -and
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/build/definitions/2?api-version=$([VSTeamVersions]::Build)"
            }
         }
      }
   }
}