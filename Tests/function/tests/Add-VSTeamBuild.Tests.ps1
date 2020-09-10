Set-StrictMode -Version Latest

Describe 'VSTeamBuild' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      . "$baseFolder/Source/Public/Get-VSTeamQueue.ps1"
      . "$baseFolder/Source/Public/Get-VSTeamBuildDefinition.ps1"
   }

   Context 'Add-VSTeamBuild' -Tag "Add" {
      ## Arrange
      BeforeAll {
         $singleResult = Open-SampleFile 'buildSingleResult.json'

         Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Build' }
      }

      Context 'Services' -Tag "Services" {
         BeforeAll {
            # Set the account to use for testing. A normal user would do this
            # using the Set-VSTeamAccount function.
            Mock _getInstance { return 'https://dev.azure.com/test' }

            Mock Invoke-RestMethod { return $singleResult }
            Mock Get-VSTeamBuildDefinition { Open-SampleFile 'buildDefvsts.json' -ReturnValue }
         }

         It 'should add build by name' {
            ## Act
            Add-VSTeamBuild -ProjectName project `
               -BuildDefinitionName 'aspdemo-CI'

            ## Assert
            # Call to queue build.
            Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Body -like "*699*" -and
               $Uri -eq "https://dev.azure.com/test/project/_apis/build/builds?api-version=$(_getApiVersion Build)"
            }
         }

         It 'should add build by id' {
            ## Act
            Add-VSTeamBuild -ProjectName project `
               -BuildDefinitionId 2

            ## Assert
            # Call to queue build.
            Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Body -like "*2*" -and
               $Uri -eq "https://dev.azure.com/test/project/_apis/build/builds?api-version=$(_getApiVersion Build)"
            }
         }

         It 'should add build with source branch' {
            ## Act
            Add-VSTeamBuild -ProjectName project `
               -BuildDefinitionId 2 `
               -SourceBranch 'refs/heads/dev'

            ## Assert
            # Call to queue build.
            Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Body -like "*2*" -and
               $Body -like "*refs/heads/dev*" -and
               $Uri -eq "https://dev.azure.com/test/project/_apis/build/builds?api-version=$(_getApiVersion Build)"
            }
         }

         It 'should add build with parameters' {
            ## Act
            Add-VSTeamBuild -ProjectName project `
               -BuildDefinitionId 2 `
               -BuildParameters @{'system.debug' = 'true' }

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
            Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' }

            Mock Invoke-RestMethod { return $singleResult }

            Mock Get-VSTeamQueue { return [PSCustomObject]@{
                  name = "MyQueue"
                  id   = 3
               }
            }

            Mock Get-VSTeamBuildDefinition { return @{ name = "MyBuildDef" } }
         }

         It 'should add build by id on TFS local auth' {
            ## Act
            Add-VSTeamBuild -projectName project `
               -BuildDefinitionId 2 `
               -QueueName MyQueue

            ## Assert
            # Call to queue build.
            Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/build/builds?api-version=$(_getApiVersion Build)" -and
               $Body -like "*2*" -and
               $Body -like "*3*"
            }
         }

         It 'should add build with parameters on TFS local auth' {
            ## Act
            Add-VSTeamBuild -projectName project `
               -BuildDefinitionId 2 `
               -QueueName MyQueue `
               -BuildParameters @{'system.debug' = 'true' }

            ## Assert
            # Call to queue build.
            Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/build/builds?api-version=$(_getApiVersion Build)" -and
               $Body -like "*2*" -and
               $Body -like "*3*" -and
               $Body -like "*system.debug*"
            }
         }

         It 'should add build with source branch on TFS local auth' {
            ## Act
            Add-VSTeamBuild -projectName project `
               -BuildDefinitionId 2 `
               -QueueName MyQueue `
               -SourceBranch refs/heads/dev

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