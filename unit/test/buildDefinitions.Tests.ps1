Set-StrictMode -Version Latest

# Loading System.Web avoids issues finding System.Web.HttpUtility
Add-Type -AssemblyName 'System.Web'

InModuleScope VSTeam {
   [VSTeamVersions]::Account = 'https://dev.azure.com/test'

   $resultsVSTS = Get-Content "$PSScriptRoot\sampleFiles\buildDefvsts.json" -Raw | ConvertFrom-Json

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
   }
}