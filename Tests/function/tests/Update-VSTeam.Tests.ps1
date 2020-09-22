Set-StrictMode -Version Latest

Describe "VSTeam" {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      . "$baseFolder/Source/Public/Get-VSTeam.ps1"
   }

   Context "Update-VSTeam" {
      Context "services" {
         BeforeAll {
            Mock _getInstance { return 'https://dev.azure.com/test' }
            Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Core' }
            Mock Invoke-RestMethod { Open-SampleFile 'Get-VSTeam.json' -Index 0 }
            Mock Get-VSTeam { return New-Object -TypeName PSObject -Prop @{
                  projectname = "TestProject"
                  name        = "OldTeamName"
               }
            }
         }

         It 'Should update the team with new team name' {
            ## Arrange
            $expectedBody = '{ "name": "NewTeamName" }'

            ## Act
            $team = Update-VSTeam -ProjectName Test -TeamToUpdate "OldTeamName" -NewTeamName "NewTeamName"

            ## Assert
            $team.Name | Should -Be 'Test Team' -Because 'Name should be set'

            Should -Invoke Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/_apis/projects/Test/teams/OldTeamName?api-version=$(_getApiVersion Core)" -and
               $Method -eq "Patch" -and
               $Body -eq $expectedBody
            }
         }

         It 'Should update the team with new description' {
            Update-VSTeam -ProjectName Test -TeamToUpdate "OldTeamName" -Description "New Description"

            $expectedBody = '{"description": "New Description" }'

            Should -Invoke Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/_apis/projects/Test/teams/OldTeamName?api-version=$(_getApiVersion Core)" -and
               $Method -eq "Patch" -and
               $Body -eq $expectedBody
            }
         }

         It 'Should update the team with new team name and description' {
            ## Arrange
            $expectedBody = '{ "name": "NewTeamName", "description": "New Description" }'

            ## Act
            Update-VSTeam -ProjectName Test -TeamToUpdate "OldTeamName" -NewTeamName "NewTeamName" -Description "New Description"

            ## Assert
            Should -Invoke Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/_apis/projects/Test/teams/OldTeamName?api-version=$(_getApiVersion Core)" -and
               $Method -eq "Patch" -and
               $Body -eq $expectedBody
            }
         }

         It 'Should update the team fed through pipeline' {
            ## Arrange
            $expectedBody = '{ "name": "NewTeamName", "description": "New Description" }'

            ## Act
            Get-VSTeam -ProjectName TestProject -TeamId "OldTeamName" | Update-VSTeam -NewTeamName "NewTeamName" -Description "New Description"

            ## Assert
            Should -Invoke Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/_apis/projects/TestProject/teams/OldTeamName?api-version=$(_getApiVersion Core)" -and
               $Method -eq "Patch" -and
               $Body -eq $expectedBody
            }
         }
      }

      Context "Server" {
         BeforeAll {
            Mock _useWindowsAuthenticationOnPremise { return $true }
            Mock Invoke-RestMethod { Open-SampleFile 'Get-VSTeam.json' -Index 0 }
            Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' }
         }

         It 'Should update the team with new team name on TFS local Auth' {
            ## Arrange
            $expectedBody = '{ "name": "NewTeamName" }'

            ## Act
            Update-VSTeam -ProjectName Test -TeamToUpdate "OldTeamName" -NewTeamName "NewTeamName"

            ## Assert
            Should -Invoke Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/_apis/projects/Test/teams/OldTeamName?api-version=$(_getApiVersion Core)" -and
               $Method -eq "Patch" -and
               $Body -eq $expectedBody
            }
         }
      }
   }
}