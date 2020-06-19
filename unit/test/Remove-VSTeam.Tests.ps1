Set-StrictMode -Version Latest

Describe "VSTeam" {
   BeforeAll {
      Import-Module SHiPS

      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

      . "$PSScriptRoot/../../Source/Classes/VSTeamLeaf.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamTeam.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProjectCache.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectCompleter.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectValidateAttribute.ps1"
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

   Context "Remove-VSTeam" {
      Context "services" {
         BeforeAll {
            Mock _getInstance { return 'https://dev.azure.com/test' }
            Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Core' }
         }

         Context 'Remove-VSTeam' {
            BeforeAll {
               Mock Invoke-RestMethod { return $singleResult }
            }

            It 'Should remove the team' {
               Remove-VSTeam -ProjectName Test -TeamId "TestTeam" -Force

               Should -Invoke Invoke-RestMethod -Exactly 1 -ParameterFilter {
                  $Uri -eq "https://dev.azure.com/test/_apis/projects/Test/teams/TestTeam?api-version=$(_getApiVersion Core)" -and
                  $Method -eq "Delete"
               }
            }
         }

         Context 'Remove-VSTeam, fed through pipeline' {
            BeforeAll {
               Mock Get-VSTeam { return New-Object -TypeName PSObject -Prop @{projectname = "TestProject"; name = "TestTeam" } }
               Mock Invoke-RestMethod { return $singleResult }
            }

            It 'Should remove the team' {
               Get-VSTeam -ProjectName TestProject -TeamId "TestTeam" | Remove-VSTeam -Force

               Should -Invoke Invoke-RestMethod -Exactly 1 -ParameterFilter {
                  $Uri -eq "https://dev.azure.com/test/_apis/projects/TestProject/teams/TestTeam?api-version=$(_getApiVersion Core)" -and
                  $Method -eq "Delete"
               }
            }
         }
      }

      Context "Server" {
         BeforeAll {
            Mock _useWindowsAuthenticationOnPremise { return $true }

            Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' }
         }

         Context 'Remove-VSTeam on TFS local Auth' {
            BeforeAll {
               Mock Invoke-RestMethod { return $singleResult }
            }

            It 'Should remove the team' {
               Remove-VSTeam -ProjectName Test -TeamId "TestTeam" -Force

               Should -Invoke Invoke-RestMethod -Exactly 1 -ParameterFilter {
                  $Uri -eq "http://localhost:8080/tfs/defaultcollection/_apis/projects/Test/teams/TestTeam?api-version=$(_getApiVersion Core)" -and
                  $Method -eq "Delete"
               }
            }
         }
      }
   }
}