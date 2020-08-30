Set-StrictMode -Version Latest

Describe 'VSTeamBuild' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      . "$baseFolder/Source/Classes/VSTeamLeaf.ps1"
      . "$baseFolder/Source/Classes/VSTeamDirectory.ps1"
      . "$baseFolder/Source/Classes/VSTeamTask.ps1"
      . "$baseFolder/Source/Classes/VSTeamAttempt.ps1"
      . "$baseFolder/Source/Classes/VSTeamEnvironment.ps1"
      . "$baseFolder/Source/Private/applyTypes.ps1"
      . "$baseFolder/Source/Public/Get-VSTeamQueue.ps1"
      . "$baseFolder/Source/Public/Remove-VSTeamAccount.ps1"
      . "$baseFolder/Source/Public/Get-VSTeamBuildDefinition.ps1"
   }

   Context 'Add-VSTeamBuild' -Tag "Add" {
      ## Arrange
      BeforeAll {
         $resultsVSTS = Get-Content "$sampleFiles\buildDefvsts.json" -Raw | ConvertFrom-Json
         $singleResult = Get-Content "$sampleFiles\buildSingleResult.json" -Raw | ConvertFrom-Json

         Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Build' }
      }

      Context 'Services' -Tag "Services" {
         BeforeAll {
            # Set the account to use for testing. A normal user would do this
            # using the Set-VSTeamAccount function.
            Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable

            Mock Invoke-RestMethod { return $singleResult }
            Mock Get-VSTeamBuildDefinition { return $resultsVSTS.value }
         }

         It 'by name should add build' {
            ## Act
            Add-VSTeamBuild -ProjectName project -BuildDefinitionName 'aspdemo-CI'

            ## Assert
            # Call to queue build.
            Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Body -like "*699*" -and
               $Uri -eq "https://dev.azure.com/test/project/_apis/build/builds?api-version=$(_getApiVersion Build)"
            }
         }

         It 'by id should add build' {
            ## Act
            Add-VSTeamBuild -ProjectName project -BuildDefinitionId 2

            ## Assert
            # Call to queue build.
            Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Body -like "*2*" -and
               $Uri -eq "https://dev.azure.com/test/project/_apis/build/builds?api-version=$(_getApiVersion Build)"
            }
         }

         It 'with source branch should add build' {
            ## Act
            Add-VSTeamBuild -ProjectName project -BuildDefinitionId 2 -SourceBranch 'refs/heads/dev'

            ## Assert
            # Call to queue build.
            Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Body -like "*2*" -and
               $Body -like "*refs/heads/dev*" -and
               $Uri -eq "https://dev.azure.com/test/project/_apis/build/builds?api-version=$(_getApiVersion Build)"
            }
         }

         It 'with parameters should add build' {
            ## Act
            Add-VSTeamBuild -ProjectName project -BuildDefinitionId 2 -BuildParameters @{'system.debug' = 'true' }

            ## Assert
            # Call to queue build.
            Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Body -like "*2*" -and
               $Body -like "*true*" -and
               $Uri -eq "https://dev.azure.com/test/project/_apis/build/builds?api-version=$(_getApiVersion Build)"
            }
         }
      }

      Context 'Server' -Tag "Server" {
         BeforeAll {
            ## Arrange
            Mock _useWindowsAuthenticationOnPremise { return $true }
            Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' } -Verifiable

            Mock Invoke-RestMethod {
               # Write-Host $args
               return $singleResult
            }

            Mock Get-VSTeamQueue { return [PSCustomObject]@{
                  name = "MyQueue"
                  id   = 3
               }
            }

            Mock Get-VSTeamBuildDefinition { return @{ name = "MyBuildDef" } }
         }

         It 'by id on TFS local Auth should add build' {
            ## Act
            Add-VSTeamBuild -projectName project -BuildDefinitionId 2 -QueueName MyQueue

            ## Assert
            # Call to queue build.
            Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/build/builds?api-version=$(_getApiVersion Build)" -and
               $Body -like "*2*" -and
               $Body -like "*3*"
            }
         }

         It 'with parameters on TFS local Auth should add build' {
            ## Act
            Add-VSTeamBuild -projectName project -BuildDefinitionId 2 -QueueName MyQueue -BuildParameters @{'system.debug' = 'true' }

            ## Assert
            # Call to queue build.
            Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/build/builds?api-version=$(_getApiVersion Build)" -and
               $Body -like "*2*" -and
               $Body -like "*3*" -and
               $Body -like "*system.debug*"
            }
         }

         It 'with source branch on TFS local auth should add build' {
            ## Act
            Add-VSTeamBuild -projectName project -BuildDefinitionId 2 -QueueName MyQueue -SourceBranch refs/heads/dev

            ## Assert
            # Call to queue build.
            Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/build/builds?api-version=$(_getApiVersion Build)" -and
               $Body -like "*2*" -and
               $Body -like "*3*" -and
               $Body -like "*refs/heads/dev*"
            }
         }
      }
   }
}