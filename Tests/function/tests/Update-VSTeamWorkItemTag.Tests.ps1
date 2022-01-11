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
            Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'WorkItemTracking' }
            Mock Invoke-RestMethod { Open-SampleFile 'Get-VSTeamWorkItemTag.json' -Index 0 }
            Mock Get-VSTeam { return New-Object -TypeName PSObject -Prop @{
                  projectname = "TestProject"
                  name        = "OldTagName"
               }
            }
         }

         It 'Should update the tag with new tag name' {

            ## Act
            $tag = Update-VSTeamWorkItemTag -ProjectName "TestProject" -TagIdOrName "OldTagName" -NewTagName "NewTagName"

            ## Assert
            $tag.Name | Should -Be 'NewTagName' -Because 'Name should be set'

            Should -Invoke Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/TestProject/_apis/wit/tags/OldTagName?api-version=$(_getApiVersion WorkItemTracking)" -and
               $Method -eq "Patch" -and
               $Body -like '*NewTagName*'
            }
         }
      }
   }
}