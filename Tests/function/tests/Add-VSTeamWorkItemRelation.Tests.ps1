Set-StrictMode -Version Latest

Describe "VSTeamWorkItemRelation" {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      . "$baseFolder/Source/Public/Update-VSTeamWorkItem.ps1"
      . "$baseFolder/Source/Public/New-VSTeamWorkItemRelation.ps1"

      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '1.0-unitTests' } #-ParameterFilter { $Service -eq 'Core' }
      Mock Invoke-RestMethod { Open-SampleFile 'Add-VSTeamWorkItemRelation-Id55.json' } -ParameterFilter { $Uri -like '*/_apis/wit/workitems/55*' -and $Method -eq 'Patch' }
      Mock New-VSTeamWorkItemRelation { return [PSCustomObject]@{ Id = 70; RelationType = 'System.LinkTypes.Hierarchy-Reverse'; Operation = 'add'; Index = '-' }} -ParameterFilter { $id -eq 70 }
   }

   Context 'Add-VSTeamWorkItemRelation' {
      It 'add work items as related of another work item and returns the related work item' {
         $actual = Add-VSTeamWorkItemRelation -Id 70 -RelationType Child -OfRelatedId 55

         $actual.Relations | Should -HaveCount 1
         $actual.Relations[0].url.split('/')[-1] | Should -Be 70
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It
         Should -Invoke New-VSTeamWorkItemRelation -Exactly -Times 1 -Scope It
      }

   }
}