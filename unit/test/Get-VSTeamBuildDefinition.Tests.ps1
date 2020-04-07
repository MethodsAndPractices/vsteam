Set-StrictMode -Version Latest
# Loading System.Web avoids issues finding System.Web.HttpUtility
Add-Type -AssemblyName 'System.Web'
$env:testing=$true
# Loading the code from source files will break if functionality moves from one file to another, instead
# the InModuleScope command allows you to perform white-box unit testing on the
# internal \(non-exported\) code of a Script Module, ensuring the module is loaded.

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

      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Build' }

      Mock Invoke-RestMethod { return $results2017 } -ParameterFilter { $Uri -like "*2017Project*" }
      Mock Invoke-RestMethod { return $results2018 } -ParameterFilter { $Uri -like "*2018Project*" }
      Mock Invoke-RestMethod { return $resultsAzD } -ParameterFilter { $Uri -like "*azd*" }
      Mock Invoke-RestMethod { return $resultsVSTS } -ParameterFilter { $Uri -like "*vsts*" }
      Mock Invoke-RestMethod { return $resultsVSTS.value } -ParameterFilter { $Uri -like "*101*" }

      Context 'Server' {
         Mock _useWindowsAuthenticationOnPremise { return $true }
         Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' }

         It 'TFS 2017 with no parameters should return build definitions' {
            ## Act
            Get-VSTeamBuildDefinition -projectName "2017Project"

            ## Assert
            Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Uri -like "*http://localhost:8080/tfs/defaultcollection/2017Project/_apis/build/definitions*" -and
               $Uri -like "*api-version=$(_getApiVersion Build)*" -and
               $Uri -like "*type=All*"
            }
         }

         It 'TFS 2018 with no parameters should return build definitions' {
            ## Act
            Get-VSTeamBuildDefinition -projectName "2018Project"

            ## Assert
            Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Uri -like "*http://localhost:8080/tfs/defaultcollection/2018Project/_apis/build/definitions*" -and
               $Uri -like "*api-version=$(_getApiVersion Build)*" -and
               $Uri -like "*type=All*"
            }
         }

         It 'by ID local auth should return build definition' {
            ## Act
            Get-VSTeamBuildDefinition -projectName project -id 101

            ## Assert
            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/build/definitions/101?api-version=$(_getApiVersion Build)"
            }
         }
      }

      Context 'Services' {
         ## Arrange
         Mock _getInstance { return 'https://dev.azure.com/test' }

         It 'AzD v5.0 of API with no parameters should return build definitions' {
            ## Act
            Get-VSTeamBuildDefinition -projectName azd

            ## Assert
            Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Uri -like "*https://dev.azure.com/test/azd/_apis/build/definitions*" -and
               $Uri -like "*api-version=$(_getApiVersion Build)*" -and
               $Uri -like "*type=All*"
            }
         }

         It 'should return build definitions' {
            ## Act
            Get-VSTeamBuildDefinition -projectName vsts

            ## Assert
            Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Uri -like "*https://dev.azure.com/test/vsts/_apis/build/definitions*" -and
               $Uri -like "*api-version=$(_getApiVersion Build)*" -and
               $Uri -like "*type=All*"
            }
         }

         It 'with type parameter should return build definitions by type' {
            ## Act
            Get-VSTeamBuildDefinition -projectName vsts -type build

            ## Assert
            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -like "*https://dev.azure.com/test/vsts/_apis/build/definitions*" -and
               $Uri -like "*api-version=$(_getApiVersion Build)*" -and
               $Uri -like "*type=build*"
            }
         }

         It 'with filter parameter should return build definitions by filter' {
            ## Act
            Get-VSTeamBuildDefinition -projectName vsts -filter 'click*'

            ## Assert
            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -like "*https://dev.azure.com/test/vsts/_apis/build/definitions*" -and
               $Uri -like "*api-version=$(_getApiVersion Build)*" -and
               $Uri -like "*name=click*" -and
               $Uri -like "*type=All*"
            }
         }

         It 'with both parameters should return build definitions by filter' {
            ## Act
            Get-VSTeamBuildDefinition -projectName vsts -filter 'click*' -type build

            ## Asset
            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -like "*https://dev.azure.com/test/vsts/_apis/build/definitions*" -and
               $Uri -like "*api-version=$(_getApiVersion Build)*" -and
               $Uri -like "*name=click*" -and
               $Uri -like "*type=build*"
            }
         }

         It 'by id should return build definition' {
            ## Act
            $b = Get-VSTeamBuildDefinition -projectName project -id 101

            ## Assert
            $b | Get-Member | Select-Object -First 1 -ExpandProperty TypeName | Should be 'Team.BuildDefinition'

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/project/_apis/build/definitions/101?api-version=$(_getApiVersion Build)"
            }
         }

         It 'by ID -Raw should return build definition' {
            ## Act
            $raw = Get-VSTeamBuildDefinition -projectName project -id 101 -Raw

            ## Assert
            $raw | Get-Member | Select-Object -First 1 -ExpandProperty TypeName | Should be 'System.Management.Automation.PSCustomObject'

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/project/_apis/build/definitions/101?api-version=$(_getApiVersion Build)"
            }
         }

         It 'by ID -Json should return build definition' {
            ## Act
            $b = Get-VSTeamBuildDefinition -projectName project -id 101 -Json

            ## Assert
            $b | Get-Member | Select-Object -First 1 -ExpandProperty TypeName | Should be 'System.String'

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/project/_apis/build/definitions/101?api-version=$(_getApiVersion Build)"
            }
         }

         It 'with revision parameter should return build definitions by revision' {
            ## Act
            Get-VSTeamBuildDefinition -projectName project -id 101 -revision 1

            ## Assert
            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/project/_apis/build/definitions/101?api-version=$(_getApiVersion Build)&revision=1"
            }
         }
      }
   }
}