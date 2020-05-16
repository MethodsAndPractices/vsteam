Set-StrictMode -Version Latest

Describe "VSTeam" {
   BeforeAll {
      Import-Module SHiPS
      
      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")
      
      . "$PSScriptRoot/../../Source/Classes/VSTeamLeaf.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProjectCache.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectCompleter.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectValidateAttribute.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamTeam.ps1"
      . "$PSScriptRoot/../../Source/Private/applyTypes.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeam.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"
      

      $singleResult = [PSCustomObject]@{
         id          = '6f365a7143e492e911c341451a734401bcacadfd'
         name        = 'refs/heads/master'
         description = 'team description'
      }
   }

   Context "Get-VSTeam" {
      Context "services" {
         BeforeAll {
            Mock _getInstance { return 'https://dev.azure.com/test' }
            Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Core' }
         }

         Context 'Update-VSTeam without name or description' {
            It 'Should throw' {
               { Update-VSTeam -ProjectName Test -TeamToUpdate "OldTeamName" } | Should -Throw
            }
         }

         Context 'Update-VSTeam with new team name' {
            BeforeAll {
               Mock Invoke-RestMethod { return $singleResult }
            }

            It 'Should update the team' {
               Update-VSTeam -ProjectName Test -TeamToUpdate "OldTeamName" -NewTeamName "NewTeamName"

               $expectedBody = '{ "name": "NewTeamName" }'

               Should -Invoke Invoke-RestMethod -Exactly 1 -ParameterFilter {
                  $Uri -eq "https://dev.azure.com/test/_apis/projects/Test/teams/OldTeamName?api-version=$(_getApiVersion Core)" -and
                  $Method -eq "Patch" -and
                  $Body -eq $expectedBody
               }
            }
         }

         Context 'Update-VSTeam with new description' {
            BeforeAll {
               Mock Invoke-RestMethod { return $singleResult }
            }

            It 'Should update the team' {
               Update-VSTeam -ProjectName Test -TeamToUpdate "OldTeamName" -Description "New Description"

               $expectedBody = '{"description": "New Description" }'

               Should -Invoke Invoke-RestMethod -Exactly 1 -ParameterFilter {
                  $Uri -eq "https://dev.azure.com/test/_apis/projects/Test/teams/OldTeamName?api-version=$(_getApiVersion Core)" -and
                  $Method -eq "Patch" -and
                  $Body -eq $expectedBody
               }
            }
         }

         Context 'Update-VSTeam with new team name and description' {
            BeforeAll {
               Mock Invoke-RestMethod { return $singleResult }
            }

            It 'Should update the team' {
               Update-VSTeam -ProjectName Test -TeamToUpdate "OldTeamName" -NewTeamName "NewTeamName" -Description "New Description"

               $expectedBody = '{ "name": "NewTeamName", "description": "New Description" }'

               Should -Invoke Invoke-RestMethod -Exactly 1 -ParameterFilter {
                  $Uri -eq "https://dev.azure.com/test/_apis/projects/Test/teams/OldTeamName?api-version=$(_getApiVersion Core)" -and
                  $Method -eq "Patch" -and
                  $Body -eq $expectedBody
               }
            }
         }

         Context 'Update-VSTeam, fed through pipeline' {
            BeforeAll {
               Mock Get-VSTeam { return New-Object -TypeName PSObject -Prop @{projectname = "TestProject"; name = "OldTeamName" } }
               Mock Invoke-RestMethod { return $singleResult }
            }

            It 'Should update the team' {
               Get-VSTeam -ProjectName TestProject -TeamId "OldTeamName" | Update-VSTeam -NewTeamName "NewTeamName" -Description "New Description"

               $expectedBody = '{ "name": "NewTeamName", "description": "New Description" }'

               Should -Invoke Invoke-RestMethod -Exactly 1 -ParameterFilter {
                  $Uri -eq "https://dev.azure.com/test/_apis/projects/TestProject/teams/OldTeamName?api-version=$(_getApiVersion Core)" -and
                  $Method -eq "Patch" -and
                  $Body -eq $expectedBody
               }
            }
         }
      }

      Context "Server" {
         BeforeAll {
            Mock _useWindowsAuthenticationOnPremise { return $true }

            Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' }
         }

         Context 'Update-VSTeam with new team name on TFS local Auth' {
            BeforeAll {
               Mock Invoke-RestMethod { return $singleResult }
            }

            It 'Should update the team' {
               Update-VSTeam -ProjectName Test -TeamToUpdate "OldTeamName" -NewTeamName "NewTeamName"

               $expectedBody = '{ "name": "NewTeamName" }'

               Should -Invoke Invoke-RestMethod -Exactly 1 -ParameterFilter {
                  $Uri -eq "http://localhost:8080/tfs/defaultcollection/_apis/projects/Test/teams/OldTeamName?api-version=$(_getApiVersion Core)" -and
                  $Method -eq "Patch" -and
                  $Body -eq $expectedBody
               }
            }
         }
      }
   }
}