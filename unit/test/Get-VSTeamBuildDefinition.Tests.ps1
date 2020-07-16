Set-StrictMode -Version Latest

BeforeAll {
   Import-Module SHiPS

   $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

   . "$PSScriptRoot/../../Source/Classes/VSTeamLeaf.ps1"
   . "$PSScriptRoot/../../Source/Classes/VSTeamDirectory.ps1"
   . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
   . "$PSScriptRoot/../../Source/Classes/VSTeamProjectCache.ps1"
   . "$PSScriptRoot/../../Source/Classes/ProjectCompleter.ps1"
   . "$PSScriptRoot/../../Source/Classes/ProjectValidateAttribute.ps1"
   . "$PSScriptRoot/../../Source/Classes/VSTeamUserEntitlement.ps1"
   . "$PSScriptRoot/../../Source/Classes/VSTeamTeams.ps1"
   . "$PSScriptRoot/../../Source/Classes/VSTeamRepositories.ps1"
   . "$PSScriptRoot/../../Source/Classes/VSTeamReleaseDefinitions.ps1"
   . "$PSScriptRoot/../../Source/Classes/VSTeamTask.ps1"
   . "$PSScriptRoot/../../Source/Classes/VSTeamAttempt.ps1"
   . "$PSScriptRoot/../../Source/Classes/VSTeamEnvironment.ps1"
   . "$PSScriptRoot/../../Source/Classes/VSTeamRelease.ps1"
   . "$PSScriptRoot/../../Source/Classes/VSTeamReleases.ps1"
   . "$PSScriptRoot/../../Source/Classes/VSTeamBuild.ps1"
   . "$PSScriptRoot/../../Source/Classes/VSTeamBuilds.ps1"
   . "$PSScriptRoot/../../Source/Classes/VSTeamQueues.ps1"
   . "$PSScriptRoot/../../Source/Classes/VSTeamBuildDefinitions.ps1"
   . "$PSScriptRoot/../../Source/Classes/VSTeamProject.ps1"
   . "$PSScriptRoot/../../Source/Classes/VSTeamGitRepository.ps1"
   . "$PSScriptRoot/../../Source/Classes/VSTeamBuildDefinitionProcessPhaseStep.ps1"
   . "$PSScriptRoot/../../Source/Classes/VSTeamBuildDefinitionProcessPhase.ps1"
   . "$PSScriptRoot/../../Source/Classes/VSTeamBuildDefinitionProcess.ps1"
   . "$PSScriptRoot/../../Source/Classes/VSTeamPool.ps1"
   . "$PSScriptRoot/../../Source/Classes/VSTeamQueue.ps1"
   . "$PSScriptRoot/../../Source/Classes/VSTeamBuildDefinition.ps1"
   . "$PSScriptRoot/../../Source/Private/common.ps1"
   . "$PSScriptRoot/../../Source/Public/$sut"
}

Describe 'VSTeamBuildDefinition' {
   Context 'Get-VSTeamBuildDefinition' {
      BeforeAll {
         $resultsAzD = Get-Content "$PSScriptRoot\sampleFiles\buildDefAzD.json" -Raw | ConvertFrom-Json
         $resultsVSTS = Get-Content "$PSScriptRoot\sampleFiles\buildDefvsts.json" -Raw | ConvertFrom-Json
         $results2017 = Get-Content "$PSScriptRoot\sampleFiles\buildDef2017.json" -Raw | ConvertFrom-Json
         $results2018 = Get-Content "$PSScriptRoot\sampleFiles\buildDef2018.json" -Raw | ConvertFrom-Json

         # Make sure the project name is valid. By returning an empty array
         # all project names are valid. Otherwise, you name you pass for the
         # project in your commands must appear in the list.
         Mock _getProjects { return @() }

         Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Build' }

         Mock Invoke-RestMethod { return $results2017 } -ParameterFilter { $Uri -like "*2017Project*" }
         Mock Invoke-RestMethod { return $results2018 } -ParameterFilter { $Uri -like "*2018Project*" }
         Mock Invoke-RestMethod { return $resultsAzD } -ParameterFilter { $Uri -like "*azd*" }
         Mock Invoke-RestMethod { return $resultsVSTS } -ParameterFilter { $Uri -like "*vsts*" }
         Mock Invoke-RestMethod { return $resultsVSTS.value } -ParameterFilter { $Uri -like "*101*" }
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
               $Uri -like "*api-version=$(_getApiVersion Build)*" -and
               $Uri -like "*type=All*"
            }
         }

         It 'TFS 2018 with no parameters should return build definitions' {
            ## Act
            Get-VSTeamBuildDefinition -projectName "2018Project"

            ## Assert
            Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Uri -like "*http://localhost:8080/tfs/defaultcollection/2018Project/_apis/build/definitions*" -and
               $Uri -like "*api-version=$(_getApiVersion Build)*" -and
               $Uri -like "*type=All*"
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
               $Uri -like "*api-version=$(_getApiVersion Build)*" -and
               $Uri -like "*type=All*"
            }
         }

         It 'should return build definitions' {
            ## Act
            Get-VSTeamBuildDefinition -projectName vsts

            ## Assert
            Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Uri -like "*https://dev.azure.com/test/vsts/_apis/build/definitions*" -and
               $Uri -like "*api-version=$(_getApiVersion Build)*" -and
               $Uri -like "*type=All*"
            }
         }

         It 'with type parameter "build" should return build definitions by type' {
            ## Arrange
            # This has not been supported since version 2.0 of the API which we 
            # no longer support. https://github.com/DarqueWarrior/vsteam/issues/87
            Mock Write-Warning

            ## Act
            Get-VSTeamBuildDefinition -projectName vsts -type build

            ## Assert
            Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -like "*https://dev.azure.com/test/vsts/_apis/build/definitions*" -and
               $Uri -like "*api-version=$(_getApiVersion Build)*" -and
               $Uri -like "*type=build*"
            }
         }

         It 'with type parameter "xaml" should return removal warning' {
            ## Arrange
            # This has not been supported since version 2.0 of the API which we 
            # no longer support. https://github.com/DarqueWarrior/vsteam/issues/87
            Mock Write-Warning
   
            Get-VSTeamBuildDefinition -ProjectName vsts -Type xaml
            
            Should -Invoke Write-Warning -Exactly -Times 1 -Scope It -ParameterFilter {
               $Message -eq "You specified -Type xaml. This parameters is ignored and will be removed in future"
            }
         }

         It 'with filter parameter should return build definitions by filter' {
            ## Act
            Get-VSTeamBuildDefinition -projectName vsts -filter 'click*'

            ## Assert
            Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -like "*https://dev.azure.com/test/vsts/_apis/build/definitions*" -and
               $Uri -like "*api-version=$(_getApiVersion Build)*" -and
               $Uri -like "*name=click*" -and
               $Uri -like "*type=All*"
            }
         }

         It 'with both parameters should return build definitions by filter' {
            ## Arrange
            # This has not been supported since version 2.0 of the API which we 
            # no longer support. https://github.com/DarqueWarrior/vsteam/issues/87
            Mock Write-Warning
            
            ## Act
            Get-VSTeamBuildDefinition -projectName vsts -filter 'click*' -type build

            ## Asset
            Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
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
            $b | Get-Member | Select-Object -First 1 -ExpandProperty TypeName | Should -Be 'Team.BuildDefinition'

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