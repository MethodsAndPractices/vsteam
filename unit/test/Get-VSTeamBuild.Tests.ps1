Set-StrictMode -Version Latest

BeforeAll {
   $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

   . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
   . "$PSScriptRoot/../../Source/Classes/VSTeamProjectCache.ps1"
   . "$PSScriptRoot/../../Source/Classes/ProjectCompleter.ps1"
   . "$PSScriptRoot/../../Source/Classes/ProjectValidateAttribute.ps1"
   . "$PSScriptRoot/../../Source/Private/common.ps1"
   . "$PSScriptRoot/../../Source/Private/applyTypes.ps1"
   . "$PSScriptRoot/../../Source/Public/$sut"
   . "$PSScriptRoot/../../Source/Public/Remove-VSTeamAccount.ps1"
}

Describe 'VSTeamBuild' {
   BeforeAll {
      ## Arrange
      # Make sure the project name is valid. By returning an empty array
      # all project names are valid. Otherwise, you name you pass for the
      # project in your commands must appear in the list.
      Mock _getProjects { return @() }

      # Sample result of a single build
      $singleResult = Get-Content "$PSScriptRoot\sampleFiles\buildSingleResult.json" -Raw | ConvertFrom-Json

      # Sample result for list of builds
      $results = Get-Content "$PSScriptRoot\sampleFiles\buildResults.json" -Raw | ConvertFrom-Json

      Mock Invoke-RestMethod { return $results }
      Mock Invoke-RestMethod { return $singleResult } -ParameterFilter { $Uri -like "*101*" }
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Build' }
   }

   Context 'Get-VSTeamBuild' {
      Context 'Services' {
         BeforeAll {
            ## Arrange
            # Set the account to use for testing. A normal user would do this
            # using the Set-VSTeamAccount function.
            Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable
         }

         It 'with no parameters should return builds' {
            ## Act
            Get-VSTeamBuild -projectName project

            ## Assert
            Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/project/_apis/build/builds?api-version=$(_getApiVersion Build)"
            }
         }

         It 'with Top parameter should return top builds' {
            ## Act
            Get-VSTeamBuild -projectName project -top 1

            ## Assert
            Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/project/_apis/build/builds?api-version=$(_getApiVersion Build)&`$top=1"
            }
         }

         It 'by id should return top builds' {
            ## Act
            Get-VSTeamBuild -projectName project -id 101

            ## Assert
            Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/project/_apis/build/builds/101?api-version=$(_getApiVersion Build)"
            }
         }
      }

      Context 'Server' {
         BeforeAll {
            ## Arrange
            Mock _useWindowsAuthenticationOnPremise { return $true }
            Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' } -Verifiable
         }

         It 'with no parameters on TFS local Auth should return builds' {
            ## Act
            Get-VSTeamBuild -projectName project

            ## Assert
            Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/build/builds?api-version=$(_getApiVersion Build)"
            }
         }

         It 'should return builds' {
            ## Act
            Get-VSTeamBuild -projectName project -id 101

            ## Assert
            Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter { $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/build/builds/101?api-version=$(_getApiVersion Build)" }
         }
      }
   }
}