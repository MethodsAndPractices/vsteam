Set-StrictMode -Version Latest

Describe "VSTeamWorkItemTag" {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      . "$baseFolder/Source/Public/Get-VSTeam.ps1"
   }

   Context "Update-VSTeamWorkItemTag" {
      Context "services" {
         BeforeAll {
            Mock _getInstance { return 'https://dev.azure.com/test' }
            Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Work Item Tracking' }
            Mock Invoke-RestMethod { Open-SampleFile 'Get-VSTeamWorkItemTag.json' -Index 0 }
            Mock Get-VSTeam { return New-Object -TypeName PSObject -Prop @{
                  projectname = "TestProject"
                  name        = "OldTeamName"
               }
            }
         }

         It 'Should update the tag with new tag name' {
            ## Arrange
            $expectedBody = '{ "name": "NewTagName" }'

            ## Act
            $team = Update-VSTeam -ProjectName Test -TeamToUpdate "OldTagName" -NewTeamName "NewTagName"

            ## Assert
            $team.Name | Should -Be 'Test Team' -Because 'Name should be set'

            Should -Invoke Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/_apis/wit/tags/OldTagName?api-version=$(_getApiVersion Work Item Tracking)" -and
               $Method -eq "Patch" -and
               $Body -eq $expectedBody
            }
         }
      }
   }
}